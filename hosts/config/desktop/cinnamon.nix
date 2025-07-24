{pkgs, ...}:
{
  services = {
    # X11 settings
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # Enable the Cinnamon Desktop Environment.
      displayManager.lightdm.enable = false;
      desktopManager.cinnamon.enable = false;
    };
  };
  environment.cinnamon.excludePackages = [ pkgs.warpinator ];
  programs.gnome-terminal.enable = false;
}