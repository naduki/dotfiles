# Zenzai (llama.cpp の llama-server と zenz のモデル)。
# native/build-core-linux.sh の「Zenzai」に相当する。llama-server は上流のように
# ソースからビルドせず (上流: native/zenzai/build-llama-server.sh)、nixpkgs の llama-cpp を使う。
# モデルの版とハッシュは Meltype の native/zenzai/zenzai.env から読む (上流が版を上げても nix 側は直さなくてよい)。
#
# 出力の配置 (fcitx5-meltype が MELTYPE_DIR/zenzai からリンクする):
#   $out/lib/meltype/zenzai/llama-server           nixpkgs の llama-server へのリンク
#   $out/lib/meltype/zenzai/zenz-v3.2-small-*.gguf  モデル (Meltype はフォルダーの *.gguf を使う)
#   $out/lib/meltype/zenzai/LICENSE-*.txt
#
# GPU 版の llama.cpp は使わない: Linux 版の Meltype は「Zenzai: 使う GPU」(ZenzaiDevice) が設定に出ず、
# llama-server に -ngl 0 を渡すので、GPU 版でも CPU で計算する。
{
  lib,
  stdenvNoCC,
  callPackage,
  fetchurl,
  llama-cpp,
  src,
}:
let
  # zenzai.env の KEY=VALUE の行だけを読む (コメント・空行は飛ばす。CRLF でも読めるように末尾の空白は捨てる)
  envLines = lib.splitString "\n" (builtins.readFile "${src}/native/zenzai/zenzai.env");
  parse = line: builtins.match "([A-Z0-9_]+)=([^[:space:]]*)[[:space:]]*" line;
  env = lib.listToAttrs (
    map (m: lib.nameValuePair (lib.elemAt m 0) (lib.elemAt m 1)) (
      lib.filter (m: m != null) (map parse envLines)
    )
  );
  need =
    key: env.${key} or (throw "meltype-zenzai: native/zenzai/zenzai.env に ${key} がありません");

  modelName = need "ZENZ_NAME";

  model = fetchurl {
    name = modelName;
    url = "https://huggingface.co/Miwa-Keita/zenz-v3.2-small-gguf/resolve/${need "ZENZ_COMMIT"}/ggml-model-Q5_K_M.gguf";
    sha256 = need "ZENZ_SHA256";
  };

  # build-core-linux.sh と同じく、zenz のライセンス (Apache-2.0) の本文を同梱する
  zenzLicense = fetchurl {
    url = "https://www.apache.org/licenses/LICENSE-2.0.txt";
    hash = "sha256-z8d0m5b2O9McPEK1xHG/dWgUBT6EfBDz6wA0F7xSPTA=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "meltype-zenzai";
  version = callPackage ./version.nix { inherit src; };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    dir="$out/lib/meltype/zenzai"
    install -dm755 "$dir"
    # llama-server の backend (libggml-cpu-*.so) は llama-cpp に埋め込まれた GGML_BACKEND_DIR から読むので、リンクだけでよい
    ln -s "${lib.getExe' llama-cpp "llama-server"}" "$dir/llama-server"
    ln -s "${model}" "$dir/${modelName}"
    install -Dm644 "${llama-cpp.src}/LICENSE" "$dir/LICENSE-llama.cpp.txt"
    install -Dm644 "${zenzLicense}" "$dir/LICENSE-zenz.txt"

    runHook postInstall
  '';

  passthru = {
    inherit model llama-cpp;
  };

  meta = {
    description = "Zenzai (llama.cpp llama-server + zenz model) bundle for Meltype";
    homepage = "https://github.com/yksr-melt/Meltype";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
