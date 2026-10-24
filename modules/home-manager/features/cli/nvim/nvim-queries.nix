{ pkgs, lib, ... }:

let
  # Single source of truth for Treesitter languages (parsers + queries)
  targetLangs = [ "bash" "dockerfile" "nix" "rust" "toml" ];

  # Use the same package set (unstable) as the parsers to avoid version mismatches
  tsPlugins = pkgs.unstable.vimPlugins;

  # Source of nvim-treesitter (where queries are located)
  tsPlugin = tsPlugins.nvim-treesitter.src;

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
  # Treesitter parsers
  programs.neovim.plugins = map (lang: tsPlugins.nvim-treesitter-parsers.${lang}) targetLangs;

  xdg.dataFile."nvim/site/queries" = {
    source = queriesDir;
    recursive = true;
  };
}
