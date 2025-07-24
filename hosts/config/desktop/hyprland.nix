{ pkgs, ...}:
{
  # Hyprland Desktop Environment.
  programs = {
    hyprland = {
      enable = true;
      # withUWSM  = true;
    };
    regreet = {
      enable = true;
      settings = {
        GTK = {
          application_prefer_dark_theme = true;
        };
        commands = {
          reboot = [ "systemctl" "reboot" ];
          poweroff = [ "systemctl" "poweroff" ];
        };
      };
    };
  };
  # services
  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.hyprland}/bin/Hyprland --config /etc/greetd/hyprland.conf";
          user = "greeter";
        };
      };
    };
  };
  hardware.bluetooth.enable = true;
  # Security
  security = {
    polkit.enable = true;
    pam.services = {
      login.enableGnomeKeyring = true;
      hyprlock = {};
    };
  };
  # Environment
  environment = {
    systemPackages = with pkgs; [
      adwaita-icon-theme
    ];
    etc."greetd/hyprland.conf".text = ''
      exec-once = ${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit
      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        disable_hyprland_qtutils_check = true
      }
      animations {
        enabled = false
      }
    '';
  };
}
