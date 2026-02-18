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
      # Auto close parentheses
      nvim-autopairs
      # Code snippets
      luasnip
      friendly-snippets
      # File explorer
      neo-tree-nvim
      # Fuzzy finder
      telescope-nvim
      telescope-fzf-native-nvim
      # Git changes
      gitsigns-nvim
      # Keymap display
      which-key-nvim
      mini-icons
      # Status line
      lualine-nvim
      lsp-progress-nvim
      nvim-web-devicons
      # integrate Direnv
      direnv-vim
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
      toggleterm-nvim
    ];
    initLua = ''${builtins.readFile ../../../../config/nvim/init.lua}'';
  };
}
