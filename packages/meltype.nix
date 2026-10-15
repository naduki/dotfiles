{ stdenv
, lib
, inputs
, autoPatchelfHook
, patchelf        # ← 明示的なRUNPATH追加用に念のため指定（stdenvにも含まれます）
, cmake
, kdePackages
, pkg-config
, unzip
, fcitx5
, icu
}:

stdenv.mkDerivation {
  pname = "meltype";
  version = "flake-managed";

  src = inputs.meltype-zip;

  # .NET NativeAOT バイナリ (libMeltypeNative.so) の埋め込みリソース保護のため strip を無効化
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    unzip
  ];

  buildInputs = [
    fcitx5
    stdenv.cc.cc.lib
    (lib.getLib icu) # ← dev ではなく共有ライブラリ側の出力を指定
  ];

  # dlopen で動的ロードされる ICU の「ライブラリ出力 (out)」を指定する
  runtimeDependencies = [
    (lib.getLib icu)
  ];

  # ZIPの解凍処理
  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  # ビルド前にソースコードから fcitx5 のディレクトリをコピーし、パスを書き換える
  preConfigure = ''
    cp -r --no-preserve=mode ${inputs.meltype-src}/linux/fcitx5 ./fcitx5-src
    cd fcitx5-src

    substituteInPlace CMakeLists.txt \
      --replace-fail '/opt/meltype' "$out/lib/meltype"
  '';

  installPhase = ''
    runHook preInstall

    cd $NIX_BUILD_TOP/Meltype-linux

    # 1. Meltype本体の配置
    meltypeDir="$out/lib/meltype"
    mkdir -p $meltypeDir
    cp -r libMeltypeNative.so mozc icon.png $meltypeDir/
    chmod 755 $meltypeDir/libMeltypeNative.so $meltypeDir/mozc/meltype_mozc_helper

    # 2. Fcitx5用アドオンの配置
    mkdir -p $out/lib/fcitx5
    mkdir -p $out/share/fcitx5/addon
    mkdir -p $out/share/fcitx5/inputmethod

    cp ../fcitx5-src/build/meltype.so $out/lib/fcitx5/
    cp fcitx5/meltype-addon.conf $out/share/fcitx5/addon/meltype.conf
    sed "s|@DIR@|$meltypeDir|g" fcitx5/meltype.conf > $out/share/fcitx5/inputmethod/meltype.conf

    runHook postInstall
  '';

  # autoPatchelfHook 実行後に、確実に libMeltypeNative.so と meltype.so の RUNPATH へ icu の lib パスを入れる
  postFixup = ''
    patchelf --add-rpath "${lib.makeLibraryPath [ icu ]}" \
      "$out/lib/meltype/libMeltypeNative.so"
    patchelf --add-rpath "${lib.makeLibraryPath [ icu ]}:$out/lib/meltype" \
      "$out/lib/fcitx5/meltype.so"
  '';
}
