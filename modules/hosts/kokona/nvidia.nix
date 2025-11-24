{ config, ... }:
{
  hardware = {
    # Likely required to run "まいてつ Last Run!!" under Wine.
    # graphics.enable32Bit = true;
    nvidia = {
      # Recommended -> stable, feature -> latest, beta -> beta
      # package = config.boot.kernelPackages.nvidiaPackages.latest;
      # Enable the NVIDIA Open Driver
      open = true;
      # Enable the nvidia-settings GUI tool
      nvidiaSettings = false;
    };
  };
}
