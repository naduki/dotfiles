# https://github.com/vimjoyer/nvim-nix-video
{ pkgs, pkgs-stable, ... }:
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

      extraPackages = with pkgs; [
        clang-tools
        fd # for telescope
        # lua-language-server
        nil
        nodejs-slim # for copilot
        shellcheck-minimal
        ripgrep # for telescope
        rust-analyzer
        # kotlin-language-server
      ];

      plugins = with pkgs-stable.vimPlugins; [
        # Language Server Protocol
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvim/plugin/lsp.lua;
        }
        # コメントアウト
        {
          plugin = comment-nvim;
          config = toLua "require(\"Comment\").setup()";
        }
        # Theme
        {
          plugin = poimandres-nvim;
          config = "colorscheme poimandres";
        }
        # 補完候補
        {
          plugin = nvim-cmp;
          config = toLuaFile ./nvim/plugin/cmp.lua;
        }
        cmp_luasnip
        cmp-nvim-lsp
        # 検索
        {
          plugin = telescope-nvim;
          config = toLuaFile ./nvim/plugin/telescope.lua;
        }
        telescope-fzf-native-nvim
        # コードのハイライト
        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-bash
            p.tree-sitter-lua
            # p.tree-sitter-python
            p.tree-sitter-json
            p.tree-sitter-rust
          ]));
          config = toLuaFile ./nvim/plugin/treesitter.lua;
        }
        # ステータスライン
        {
          plugin = lualine-nvim;
          config = toLuaFile ./nvim/plugin/lualine.lua;
        }
        nvim-web-devicons
        # Copilot
        {
          plugin = copilot-lua;
          config = toLuaFile ./nvim/plugin/copilot_lua.lua;
        }
        copilot-cmp
        copilot-lualine
        # スニペット
        luasnip
        friendly-snippets
        # ファイラ
        neo-tree-nvim
        # Nix用
        vim-nix
      ];

      extraLuaConfig = ''
        ${builtins.readFile ./nvim/options.lua}
      '';
    };
}
