{ pkgs, ... }:
{
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = false;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      bash-language-server
      clang-tools
      lldb
      nixd
      nixfmt
      shellcheck-minimal
      # for telescope
      fd 
      ripgrep
    ];

    extraLuaPackages = luaPkgs: with luaPkgs; [
      jsregexp
    ];

    plugins = with pkgs.vimPlugins; [
      # Theme
      poimandres-nvim
      # Autocompletion
      nvim-cmp
      cmp_luasnip
      cmp-nvim-lsp
      # Fuzzy finder
      telescope-nvim
      telescope-fzf-native-nvim
      # Status line
      lualine-nvim
      lsp-progress-nvim
      nvim-web-devicons
      # Code snippets
      luasnip
      friendly-snippets
      # File explorer
      neo-tree-nvim
      # 自動で括弧を閉じる
      nvim-autopairs
      # キーマップ表示
      which-key-nvim
      mini-icons
      # Gitの変更表示
      gitsigns-nvim
      # Syntax highlighting
      (nvim-treesitter.withPlugins (p: with p; [
        bash
        cuda
        json
        nix
        python
        rust
        toml
        yaml
      ]))
    ];
    initLua = ''${builtins.readFile ../../../../config/nvim/init.lua}'';
  };
}
