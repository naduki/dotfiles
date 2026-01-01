{ pkgs, ... }:

{
  imports = [
    ./gtk-theme.nix
  ];

  programs = {
    # Automatically start Sway on tty1. If it fails or is run on another virtual terminal, set LANG=C.
    bash.initExtra = ''
      [ -z "$DISPLAY" ] && { [ "''${XDG_VTNR:-0}" -eq 1 ] && exec sway || export LANG=C; }
    '';
  };

  # Enable playerctld daemon for media player control
  services.playerctld.enable = true;

  # --- Cursor Theme Settings ---
  home.pointerCursor = {
    gtk.enable = true;
    name = "catppuccin-mocha-teal-cursors";
    package = pkgs.catppuccin-cursors.mochaTeal;
    size = 24;
  };

  # --- Qt Theme Settings ---
  qt = {
    enable = true;
    platformTheme.name = "gtk"; # Match Qt apps to GTK theme
    style.name = "gtk2";
  };

  # --- Essential Packages (from illogical-impulse.nix & sway.nix) ---
  home.packages = with pkgs; [
    # GUI Tools
    pavucontrol
    
    # Sway Essentials
    wofi          # Launcher
    swaylock      # Screen lock
    swayidle      # Idle management
    mako          # Notifications
    wlogout       # Logout menu
    waybar        # Status bar
    
    # Utilities
    libnotify
    wl-clipboard
    grim          # Screenshot
    slurp         # Region selection
    playerctl     # Media key control
  ];

  # --- Configuration Files Management ---
  xdg.configFile = {
    "sway/config".source = ../../../config/sway/config;
    "sway/cheatsheet.txt".source = ../../../config/sway/cheatsheet.txt;
    "waybar/config".source = ../../../config/waybar/config;
    "waybar/style.css".source = ../../../config/waybar/style.css;
    "wlogout/layout".source = ../../../config/wlogout/layout;
    "wlogout/style.css".source = ../../../config/wlogout/style.css;
    "swaylock/config".source = ../../../config/swaylock/config;
    # Icons for wlogout (recursive copy is not directly supported by source, so we link the directory if possible or individual files)
    # For simplicity, we assume icons are handled by the previous manual copy or we can link the directory if it exists in the repo
    # "wlogout/icons".source = ../../../config/wlogout/icons; 
  };
}