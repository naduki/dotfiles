{
  systemd.user.tmpfiles.rules = [
    # Chromium
    # "d /tmp/chromium 0700 - - -"
    # "L+ %h/.cache/chromium - - - - /tmp/chromium"
    # fontconfig
    "d /tmp/fontconfig 0700 - - -"
    "L+ %h/.cache/fontconfig - - - - /tmp/fontconfig"
    # nvidia
    "d /tmp/nvidia 0700 - - -"
    "L+ %h/.cache/nvidia - - - - /tmp/nvidia"
  ];
}
