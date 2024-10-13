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
      enable = false;
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
    # Incus Setting
    incus = {
      enable = true;
      package = pkgs.incus;
      # preseed = {};
    };
    # Cinnamon Wayland が十分使えるので導入してもいいかも
    # waydroid.enable = false;
  };

  # incus 使用時は必ず nftables を使う
  # Docker と libvirted は iptables の方がいい?
  #  → Incus で Docker と KVM/QEMU をカバーできるっぽい
  networking.nftables.enable = (config.virtualisation.incus.enable);

  # Docker / Podman GPU
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
