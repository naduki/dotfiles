{ config, pkgs, ... }:
{
  # Power Menu script
  home.packages = [
    (pkgs.writeShellApplication {
      name = "power-menu";
      # swaymsg / systemctl are taken from the system PATH to match the running versions
      runtimeInputs = [
        config.programs.fuzzel.package
        config.programs.swaylock.package
      ];
      text = ''
        options="  Lock\n󰤄  Sleep\n󰍃  Logout\n󰜉  Reboot\n󰐥  Shutdown"

        choice=$(echo -e "$options" | fuzzel --dmenu -w 20 -l 5 --prompt "Power 󰐥 ")

        case "$choice" in
            ("  Lock")
                swaylock
                ;;
            ("󰤄  Sleep")
                systemctl suspend
                ;;
            ("󰍃  Logout")
                swaymsg exit
                ;;
            ("󰜉  Reboot")
                systemctl reboot
                ;;
            ("󰐥  Shutdown")
                systemctl poweroff
                ;;
            (*)
                exit 0
                ;;
        esac
      '';
    })
  ];
}
