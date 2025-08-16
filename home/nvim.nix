# https://github.com/vimjoyer/nvim-nix-video
{ pkgs, ... }:
{
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
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
        # kdePackages.qtdeclarative
        nil
        shellcheck-minimal
        ripgrep # for telescope
        rust-analyzer
        # kotlin-language-server
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
          config = toLuaFile ./nvim/plugin/cmp.lua;
        }
        cmp_luasnip
        cmp-nvim-lsp
        # Fuzzy finder
        {
          plugin = telescope-nvim;
          config = toLuaFile ./nvim/plugin/telescope.lua;
        }
        telescope-fzf-native-nvim
        # Syntax highlighting
        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-bash
            p.tree-sitter-cuda
            p.tree-sitter-lua
            p.tree-sitter-make
            p.tree-sitter-nix
            p.tree-sitter-rust
          ]));
          config = toLuaFile ./nvim/plugin/treesitter.lua;
        }
        # Status line
        {
          plugin = lualine-nvim;
          config = toLuaFile ./nvim/plugin/lualine.lua;
        }
        lsp-progress-nvim
        nvim-web-devicons
        # GitHub Copilot
        {
          plugin = copilot-lua;
          config = toLuaFile ./nvim/plugin/copilot_lua.lua;
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

      extraLuaConfig = ''
        ${builtins.readFile ./nvim/options.lua}
      '';
    };
}
