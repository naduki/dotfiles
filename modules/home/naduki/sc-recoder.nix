{
  # Screen recording script
  xdg.configFile."screen-record.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p libnotify

      # Check if wf-recorder is running
      if pgrep -x "wf-recorder" > /dev/null; then
          pkill -INT wf-recorder
          notify-send "Screen Recording" "Recording stopped and saved."
      else
          # Define file name with timestamp
          FILENAME="$HOME/Videos/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

          # Ensure Videos directory exists
          mkdir -p "$HOME/Videos"

          # Select region with slurp
          REGION=$(slurp)

          # If selection was cancelled (empty region), exit
          if [ -z "$REGION" ]; then
              exit 0
          fi

          # Start recording
          # -g: geometry from slurp
          # -f: output file
          notify-send "Screen Recording" "Recording started..."
          wf-recorder -g "$REGION" -f "$FILENAME" &
      fi
    '';
  };
}