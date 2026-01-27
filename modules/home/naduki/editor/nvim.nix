# https://github.com/vimjoyer/nvim-nix-video
{ pkgs, ... }:
{
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
      myconfigDir = "../../../../config/nvim";
    in
    {
      # package = pkgs-stable.neovim;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true; # for copilot
      withRuby = false;
      withPython3 = false;

      extraPackages = with pkgs; [
        bash-language-server
        clang-tools
        fd # for telescope
        nixd # nil
        nixfmt-rfc-style
        shellcheck-minimal
        ripgrep # for telescope
        rust-analyzer
      ];

      plugins = with pkgs.vimPlugins; [
        # Comment support
        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }
        # Color theme
        {
          plugin = poimandres-nvim;
          config = "colorscheme poimandres";
        }
        # Autocompletion
        {
          plugin = nvim-cmp;
          config = toLuaFile ./${myconfigDir}/plugin/cmp.lua;
        }
        cmp_luasnip
        cmp-nvim-lsp
        # Fuzzy finder
        {
          plugin = telescope-nvim;
          config = toLuaFile ./${myconfigDir}/plugin/telescope.lua;
        }
        telescope-fzf-native-nvim
        # Syntax highlighting
        {
          plugin = (nvim-treesitter.withPlugins (p: with p; [
            tree-sitter-bash
            tree-sitter-cuda
            tree-sitter-lua
            tree-sitter-make
            tree-sitter-nix
            tree-sitter-rust
          ]));
          config = toLuaFile ./${myconfigDir}/plugin/treesitter.lua;
        }
        # Status line
        {
          plugin = lualine-nvim;
          config = toLuaFile ./${myconfigDir}/plugin/lualine.lua;
        }
        lsp-progress-nvim
        nvim-web-devicons
        # GitHub Copilot
        {
          plugin = copilot-lua;
          config = toLuaFile ./${myconfigDir}/plugin/copilot_lua.lua;
        }
        copilot-cmp
        copilot-lualine
        # Code snippets
        luasnip
        friendly-snippets
        # File explorer
        neo-tree-nvim
        # Nix language support
        vim-nix
      ];

      initLua = ''
        ${builtins.readFile ./${myconfigDir}/options.lua}
      '';
    };
}
