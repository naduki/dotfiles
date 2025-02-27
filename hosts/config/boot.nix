{
  boot = {
    loader = {
      # Use systemd-boot
      systemd-boot.enable = true;
      # 起動時のEFI変数の書き換えの許可?
      # efi.canTouchEfiVariables = true;
      # GPUドライバー使用中に、CUIの解像度を最適な値にする
      systemd-boot.consoleMode = "max";
      timeout = 10;
    };
    # Enable AMD P-State driver
    kernelParams = [ "amd_pstate=active" ];
  };
}