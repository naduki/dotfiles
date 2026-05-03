{ pkgs, lib, ... }:

let
  targetLangs = [ "bash" "dockerfile" "nix" "rust" "toml" ];

  # nvim-treesitter のソース（クエリが含まれる場所）
  # nixpkgs のプラグインパッケージを使用
  tsPlugin = pkgs.vimPlugins.nvim-treesitter.src;

  queriesDir = pkgs.runCommand "nvim-ts-queries" {} ''
    mkdir -p $out

    ${lib.concatMapStringsSep "\n" (lang: ''
      src_dir="${tsPlugin}/runtime/queries/${lang}"

      # ディレクトリが存在するか厳密にチェックし、無ければビルドを失敗させる
      if [ -d "$src_dir" ]; then
        cp -r "$src_dir" $out/
      else
        echo "========================================"
        echo "ERROR: ${lang} のクエリが見つかりません！"
        echo "参照先: $src_dir"
        echo "========================================"
        exit 1
      fi
    '') targetLangs}
  '';
in
{
  xdg.dataFile."nvim/site/queries" = {
    source = queriesDir;
    recursive = true;
  };
}
