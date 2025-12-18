{ inputs, lib, myconf, pkgs, pkgs-stable, ... }:
{
  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
  };

  programs = {
    hyprshot.enable = true;
    micro.package = lib.mkForce pkgs-stable.micro-with-wl-clipboard;
  };
  dbus.packages = [ pkgs-stable.nemo-with-extensions ];
  
  home = {
    sessionVariables = { } // lib.optionalAttrs (builtins.length myconf.environment == 1) {
      NIX_GSETTINGS_OVERRIDES_DIR = "${pkgs-stable.cinnamon-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
    };
    packages = with pkgs-stable; [
      ## Screenshot
      imagemagick ## _light not work (need image format support)
      slurp
      wf-recorder

      ## Switchwall
      xdg-user-dirs
      mpvpaper

      ## etc ...
      pavucontrol
    ];
    # --- Cursor Theme Settings ---
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "catppuccin-mocha-teal-cursors";
      package = pkgs-stable.catppuccin-cursors.mochaTeal;
      size = 24;
    };
  };
}
