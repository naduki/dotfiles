{ lib, ... }:
{
  boot = {
    loader = {
      # Use systemd-boot
      systemd-boot = {
        enable = lib.mkForce false;
        # GPUドライバー使用中に、CUIの解像度を最適な値にする
        consoleMode = "max";
      };
      limine = {
        enable = true;
        secureBoot.enable = true; # Enable secure boot
      };
      timeout = 10;
    };
    # Enable AMD P-State driver
    kernelParams = [ "amd_pstate=active" ];
  };
}
