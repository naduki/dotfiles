{pkgs, ...}:
{
  programs = {
    hyprland = {
      enable = true;
      withUWSM  = true;
    };
    # nm-applet.enable = true;
  };
  hardware.bluetooth.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  security.pam.services = {
    hyprlock = {};
  };
  # Override packages
  nixpkgs.config.packageOverrides = pkgs: {
    colloid-icon-theme = pkgs.colloid-icon-theme.override { colorVariants = ["teal"]; };
  };
  environment.systemPackages = with pkgs; [
    colloid-icon-theme
  ];

  # Optional, hint Electron apps to use Wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}