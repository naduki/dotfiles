{
  # Power Menu script
  xdg.configFile."power-menu.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

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
  };
}