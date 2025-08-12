{ pkgs, ...}:
{
  services = {
    # X11 settings
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Exclude X11 package
      # excludePackages = [ pkgs.xterm ];
      # Enable the Cinnamon Desktop Environment.
      displayManager.lightdm.enable = false;
      desktopManager.cinnamon.enable = true;
    };
  };
  environment.cinnamon.excludePackages = [ pkgs.warpinator ];
  programs.gnome-terminal.enable = false;
}