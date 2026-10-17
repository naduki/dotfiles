# Mozc の変換ヘルパー (meltype_mozc_helper)。
# native/mozc/build-mozc-helper.sh に相当する (Mozc を取得 → ヘルパーのソースと BUILD を足す → Bazel でビルド)。
#
# Bazel の外部依存 (BCR のモジュール、Python のツールチェーンなど) は、ネットワークに出られる
# fixed-output derivation (FOD) で `bazel vendor` して取り、本番のビルドはネットワーク無しで行う。
# FOD はハッシュが要るので、Mozc の commit とハッシュを ./mozc-pin.json に書いておく。
#
# Meltype 側の native/mozc/MOZC_COMMIT が mozc-pin.json と違うときは、評価の時点で止めて
# 更新の方法を出す (./update-mozc-pin.sh で書き換えられる)。
{
  lib,
  stdenv,
#  callPackage,
  fetchFromGitHub,
  writeText,
  bazel_9,
  autoPatchelfHook,
  lndir,
  coreutils,
  gnugrep,
  libxcrypt-legacy,
  zlib,
  src,
  # 評価時の MOZC_COMMIT の照合を飛ばす (update-mozc-pin.sh が使う)
  pin ? lib.importJSON ./mozc-pin.json,
}:
let
  system = stdenv.hostPlatform.system;

  wantedCommit = lib.trim (builtins.readFile "${src}/native/mozc/MOZC_COMMIT");

  pinChecked =
    if wantedCommit == pin.commit then
      pin
    else
      throw ''
        meltype-mozc-helper: Meltype の native/mozc/MOZC_COMMIT が変わりました。
          MOZC_COMMIT     : ${wantedCommit}
          mozc-pin.json   : ${pin.commit}
        packages/meltype/update-mozc-pin.sh を実行して packages/meltype/mozc-pin.json を更新してください。
      '';

  vendorHash =
    pinChecked.vendorHash.${system}
      or (throw "meltype-mozc-helper: packages/meltype/mozc-pin.json に ${system} の vendorHash がありません");

  mozcSrc = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    rev = pinChecked.commit;
    hash = pinChecked.hash;
  };

  # Meltype のソースのうち、Bazel の依存の取得に関わるのは BUILD.fragment だけ。
  # Meltype のほかの変更で FOD を取り直さないように、中身だけを取り出す (store path への参照を外す)。
  buildFragment = writeText "meltype-mozc-BUILD.fragment" (
    builtins.unsafeDiscardStringContext (builtins.readFile "${src}/native/mozc/BUILD.fragment")
  );

  targets = [ "//converter:meltype_mozc_helper" ];
  bazelFlags = [
    "--config"
    "oss_linux"
    "--config"
    "release_build"
  ];

  bazel = bazel_9;

  # ヘルパーの BUILD 定義を Mozc の converter パッケージに足す (build-mozc-helper.sh と同じ)。
  addFragment = ''
    if ! grep -q 'name = "meltype_mozc_helper"' converter/BUILD.bazel; then
      printf '\n' >> converter/BUILD.bazel
      cat ${buildFragment} >> converter/BUILD.bazel
    fi
  '';

  # Stage 1: `bazel vendor` で外部依存を取る (ネットワークあり、出力のハッシュを固定)。
  vendorStage1 = stdenv.mkDerivation {
    name = "meltype-mozc-helper-vendor-stage1";
    src = mozcSrc;
    sourceRoot = "source/src";

    nativeBuildInputs = [ bazel ];

    postPatch = addFragment + ''
      # vendor ではソースの中身は使わないので、空のファイルで足りる。
      touch converter/meltype_mozc_helper.cc
    '';

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      mkdir vendor_dir
      bazel --batch vendor \
        --vendor_dir="$PWD/vendor_dir" \
        --repo_contents_cache= \
        ${lib.escapeShellArgs (bazelFlags ++ targets)}

      # $HOME (Bazel の output base) を指すシンボリックリンクや、壊れたリンクを消す
      find vendor_dir -type l -lname "$HOME/*" -exec rm '{}' \;
      find vendor_dir -xtype l -exec rm '{}' \;
      # FOD は store path を参照できないので、それを含む marker を消す
      (${gnugrep}/bin/grep -rlI "$NIX_STORE/" vendor_dir --include='*.marker' --null || true) \
        | xargs -0 --no-run-if-empty rm

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r --reflink=auto vendor_dir $out/vendor_dir
      # Mozc は MODULE.bazel.lock をコミットしていない。Bazel は lockfile にチェックサムが
      # 載っているレジストリのファイルしか vendor_dir から読まないので、できた lockfile も残す。
      cp MODULE.bazel.lock $out/MODULE.bazel.lock
      runHook postInstall
    '';

    dontFixup = true;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = vendorHash;
  };

  # Stage 2: 取ってきたビルド済みのツール (Python・protoc など) を NixOS で動くように patchelf する。
  vendorDeps = stdenv.mkDerivation {
    name = "meltype-mozc-helper-vendor";
    src = vendorStage1;
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      stdenv.cc.cc.lib
      zlib
      libxcrypt-legacy
    ];
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      cp -r . $out
    '';
  };
in
stdenv.mkDerivation {
  pname = "meltype-mozc-helper";
  version = "0-unstable-mozc-${lib.substring 0 7 pinChecked.commit}";

  src = mozcSrc;
  sourceRoot = "source/src";

  nativeBuildInputs = [
    bazel
    autoPatchelfHook
  ];
  buildInputs = [ stdenv.cc.cc.lib ];

  postPatch = ''
    cp ${src}/native/mozc/meltype_mozc_helper.cc converter/
  ''
  + addFragment;

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)

    # vendor のときにできた lockfile を使う (レジストリのファイルを vendor_dir から読ませるため)
    install -m644 ${vendorDeps}/MODULE.bazel.lock MODULE.bazel.lock

    # vendor_dir は書き込める必要があるので、リンクで組み立てる
    mkdir vendor_dir
    ${lndir}/bin/lndir -silent ${vendorDeps}/vendor_dir vendor_dir
    # すべての依存を固定し、取り直しに行かせない
    rm -f vendor_dir/VENDOR.bazel
    find vendor_dir -mindepth 1 -maxdepth 1 -type d -not -name '_registries' -printf 'pin("@@%P")\n' > vendor_dir/VENDOR.bazel

    # Nix のサンドボックスには /usr/bin/env が無い。rules_python が作る py_binary のスタブなどが
    # 使うので、vendor した依存と Mozc のソースの中の参照を coreutils の env に書き換える。
    # (vendor_dir のファイルはストアへのリンクだが、sed -i は実体のファイルに置き換えてくれる)
    grep -RlI --null '/usr/bin/env' . \
      | xargs -0 --no-run-if-empty sed -i 's|/usr/bin/env|${coreutils}/bin/env|g'

    bazel --batch build \
      --vendor_dir="$PWD/vendor_dir" \
      --repo_contents_cache= \
      ${lib.escapeShellArgs (bazelFlags ++ targets)}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 bazel-bin/converter/meltype_mozc_helper "$out/lib/meltype/mozc/meltype_mozc_helper"
    install -Dm644 data/installer/credits_en.html "$out/lib/meltype/mozc/MOZC-CREDITS.html"
    install -Dm644 ../LICENSE "$out/lib/meltype/mozc/MOZC-LICENSE.txt"

    runHook postInstall
  '';

  passthru = {
    inherit mozcSrc vendorStage1 vendorDeps;
    mozcCommit = pinChecked.commit;
  };

  meta = {
    description = "Mozc conversion helper for Meltype";
    homepage = "https://github.com/yksr-melt/Meltype";
    license = with lib.licenses; [
      gpl3Plus # meltype_mozc_helper.cc
      bsd3 # Mozc
    ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
