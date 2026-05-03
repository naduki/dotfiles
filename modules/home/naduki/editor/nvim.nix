{ pkgs, ... }:
{
  imports = [ ./nvim-queries.nix ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "poimandres.nvim"
  ];

  programs.neovim = {
    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;

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
      # Integrate Direnv
      direnv-vim
      # Keymap display
      which-key-nvim
      mini-icons
      # Status line
      lualine-nvim
      lsp-progress-nvim
      nvim-web-devicons
      # Terminal
      toggleterm-nvim
      # Treesitter
      nvim-treesitter-parsers.bash
      nvim-treesitter-parsers.dockerfile
      nvim-treesitter-parsers.nix
      nvim-treesitter-parsers.rust
      nvim-treesitter-parsers.toml
    ];
    initLua = ''${builtins.readFile ../../../../config/nvim/init.lua}'';
  };
  programs.bash.historyIgnore = [ "nvim" ];
}
