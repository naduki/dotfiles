# https://github.com/vimjoyer/nvim-nix-video
{ pkgs-stable, ... }:
{
  programs.neovim =
    let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
    in
    {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      extraPackages = with pkgs-stable; [
        clang-tools
        # lua-language-server
        nil
        shellcheck-minimal
        rust-analyzer
        # kotlin-language-server
      ];

      plugins = with pkgs-stable.vimPlugins; [

        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvim/plugin/lsp.lua;
        }
        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }
        {
          plugin = poimandres-nvim;
          config = "colorscheme poimandres";
        }
        {
          plugin = nvim-cmp;
          config = toLuaFile ./nvim/plugin/cmp.lua;
        }
        {
          plugin = telescope-nvim;
          config = toLuaFile ./nvim/plugin/telescope.lua;
        }
        telescope-fzf-native-nvim
        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-python
            p.tree-sitter-json
            p.tree-sitter-rust
          ]));
          config = toLuaFile ./nvim/plugin/treesitter.lua;
        }
        nvim-cmp
        cmp_luasnip
        cmp-nvim-lsp

        luasnip
        neodev-nvim
        friendly-snippets

        neo-tree-nvim
        lualine-nvim
        nvim-web-devicons
        vim-nix
      ];

      extraLuaConfig = ''
        ${builtins.readFile ./nvim/options.lua}
      '';
    };
}
