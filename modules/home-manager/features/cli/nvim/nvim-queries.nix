{ pkgs, lib, ... }:

let
  targetLangs = [ "bash" "dockerfile" "nix" "rust" "toml" ];

  # Source of nvim-treesitter (where queries are located)
  # Use the plugin package from nixpkgs
  tsPlugin = pkgs.vimPlugins.nvim-treesitter.src;

  queriesDir = pkgs.runCommand "nvim-ts-queries" {} ''
    mkdir -p $out

    ${lib.concatMapStringsSep "\n" (lang: ''
      src_dir="${tsPlugin}/runtime/queries/${lang}"

      # Strictly check if the directory exists, and fail the build if it does not
      if [ -d "$src_dir" ]; then
        cp -r "$src_dir" $out/
      else
        echo "========================================"
        echo "ERROR: Queries for ${lang} not found!"
        echo "Target path: $src_dir"
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
