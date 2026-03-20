{
  systemd.user.tmpfiles.rules = [
    # BraveSoftware
    "d /tmp/BraveSoftware 0700 - - -"
    "L+ %h/.cache/BraveSoftware - - - - /tmp/BraveSoftware"
    # Chromium
    # "d /tmp/chromium 0700 - - -"
    # "L+ %h/.cache/chromium - - - - /tmp/chromium"
    # fontconfig
    "d /tmp/fontconfig 0700 - - -"
    "L+ %h/.cache/fontconfig - - - - /tmp/fontconfig"
    # ms-playwright-go
    "d /tmp/ms-playwright-go 0700 - - -"
    "L+ %h/.cache/ms-playwright-go - - - - /tmp/ms-playwright-go"
    # nvidia
    "d /tmp/nvidia 0700 - - -"
    "L+ %h/.cache/nvidia - - - - /tmp/nvidia"
  ];
}
