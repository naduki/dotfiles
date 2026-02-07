{
  systemd.user.tmpfiles.rules = [
    # BraveSoftwareのキャッシュ
    "d /tmp/BraveSoftware 0700 - - -"
    "L+ %h/.cache/BraveSoftware - - - - /tmp/BraveSoftware"
    # ms-playwright-goのキャッシュ
    "d /tmp/ms-playwright-go 0700 - - -"
    "L+ %h/.cache/ms-playwright-go - - - - /tmp/ms-playwright-go"
    # nvidiaのキャッシュ
    "d /tmp/nvidia 0700 - - -"
    "L+ %h/.cache/nvidia - - - - /tmp/nvidia"
  ];
}