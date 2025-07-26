{ pkgs, ... }:
{
  programs.regreet = {
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

  environment.etc."greetd/hyprland.conf".text = ''
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland --config /etc/greetd/hyprland.conf";
        user = "greeter";
      };
    };
  };
}
