{ config, lib, ... }:
{
  hardware = {
    # Likely required to run "まいてつ Last Run!!" under Wine.
    # graphics.enable32Bit = true;
    nvidia = {
      # Modesetting is required for Wayland
      modesetting.enable = true;
      # Power management is required to suspend/resume
      powerManagement.enable = true;
      # Enable the NVIDIA Open Driver
      open = true;
      # Enable the nvidia-settings GUI tool
      nvidiaSettings = false;
    };
    nvidia-container-toolkit.enable = (lib.lists.elem "nvidia" config.services.xserver.videoDrivers);
  };
}
