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
    # Enable Podman
    podman.enable = true;
    # Cinnamon Wayland が十分使えるので導入してもいいかも
    # waydroid.enable = false;
    # Incus Setting このままだとGPUが使えない
    incus = {
      enable = false;
      package = pkgs.incus;
      # preseed = {};
    };
  };

  # incus 使用時は必ず nftables を使う
  # libvirted は iptables の方がいい
  #  → Incus で Docker と KVM/QEMU をカバーできるっぽい
  networking.nftables.enable = (config.virtualisation.incus.enable);
  # incusブリッジがインターネットにアクセスできるようにする
  networking.firewall.trustedInterfaces = if config.virtualisation.incus.enable then [ "incusbr0" ] else [];

  # Container GPU
  hardware.nvidia-container-toolkit = {
    enable = (config.virtualisation.podman.enable);
    # mounts = [ nvidia.com/gpu=0 ];
  };

  environment.systemPackages = with pkgs; if config.virtualisation.libvirtd.enable then
    [
      win-spice # KVM qemu の WindowsでUSBが使えるようになる？
      virtio-win
    ]
  else [ ];
}
