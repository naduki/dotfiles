{ config, pkgs, ... }:
{
  # Screen recording script
  home.packages = [
    (pkgs.writeShellApplication {
      name = "screen-record";
      runtimeInputs = with pkgs; [
        coreutils
        libnotify
        procps
        slurp
        wf-recorder
      ];
      text = ''
        VIDEOS_DIR="${config.xdg.userDirs.videos}"

        # Check if wf-recorder is running
        if pgrep -x "wf-recorder" > /dev/null; then
            pkill -INT wf-recorder
            notify-send "Screen Recording" "Recording stopped and saved."
        else
            # Define file name with timestamp
            FILENAME="$VIDEOS_DIR/recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

            # Ensure Videos directory exists
            mkdir -p "$VIDEOS_DIR"

            # Select region with slurp
            # (slurp exits non-zero when the selection is cancelled)
            REGION=$(slurp) || exit 0

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
    })
  ];
}
