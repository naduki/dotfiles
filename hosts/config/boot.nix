{ lib, ... }:
{
  boot = {
    loader = {
      # Use systemd-boot
      systemd-boot = {
        enable = lib.mkForce false;
        # sSet the console resolution to the optimal value when using GPU drivers
        consoleMode = "max";
      };
      limine = {
        enable = true;
        secureBoot.enable = true; # Enable secure boot
      };
      timeout = 15;
    };
    # Enable AMD P-State driver
    kernelParams = [ "amd_pstate=active" ];
  };
}
