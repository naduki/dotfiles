{ pkgs, ... }:
{
  services = {
    # X11 settings
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Exclude X11 package
      # excludePackages = [ pkgs.xterm ];
      # Enable the Cinnamon Desktop Environment.
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
  environment.cinnamon.excludePackages = [ pkgs.warpinator ];
  programs.gnome-terminal.enable = false;
}
