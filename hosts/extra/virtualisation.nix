{ config, pkgs, ... }:
{
  virtualisation = {
    # KVM/QEMU Host Setting 
    libvirtd = {
      enable = false;
      qemu = {
        # Enable TPM(Windows11)
        swtpm.enable = (config.virtualisation.libvirtd.enable);
        # Enable UEFI
        ovmf = {
          enable = (config.virtualisation.libvirtd.enable);
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    # Docker Setting
    # rootless は docker グループにユーザ追加で対応
    docker = {
      enable = true;
      storageDriver = "btrfs";
      # rootless = {
      #     enable = true;
      #     setSocketVariable = true;
      #     # gpuを使えるようにしたい
      #     daemon.settings = {
      #         features = ''
      #             "cdi": true
      #         '';
      #         cdi-spec-dirs =  [ "/var/run/cdi" ];
      #     };
      # };
    };
  };

  # Docker GPU
  hardware.nvidia-container-toolkit = {
    enable = (config.virtualisation.docker.enable);
    # mounts = [ nvidia.com/gpu=0 ];
  };

  environment.systemPackages = with pkgs; if config.virtualisation.libvirtd.enable then
    [
      win-spice # KVM qemu の WindowsでUSBが使えるようになる？
      virtio-win
    ] 
  else if config.virtualisation.docker.enable then [ docker-compose ]
  else [ ];
}
