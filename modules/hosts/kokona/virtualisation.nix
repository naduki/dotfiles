{ config, lib, myconf, pkgs, ... }:
let
  EnableNvidia = (lib.lists.elem "nvidia" config.services.xserver.videoDrivers);
in
{
  virtualisation = {
    # KVM/QEMU host settings
    libvirtd = {
      enable = false;
      qemu = {
        # Enable UEFI support
        ovmf = {
          enable = (config.virtualisation.libvirtd.enable);
          packages = [ pkgs.OVMFFull.fd ];
        };
        # Enable TPM for Windows 11
        swtpm.enable = (config.virtualisation.libvirtd.enable);
      };
    };
    # Incus settings - GPU passthrough not configured yet
    incus = {
      enable = false;
      package = pkgs.incus;
      # preseed = {};
    };
  };
  # KVM/QEMU extra packages
  environment.systemPackages = with pkgs; if config.virtualisation.libvirtd.enable then
    [
      win-spice # Enable USB support for Windows guests in KVM/QEMU
      virtio-win
    ]
  else [ ];
  # Container GPU acceleration
  hardware.nvidia-container-toolkit = {
    enable = (EnableNvidia && (myconf.VirtualizationGPU || config.virtualisation.incus.enable));
    # mounts = [ nvidia.com/gpu=0 ];
  };

  networking = {
    # Use nftables when incus is enabled
    # libvirtd works better with iptables
    # Note: Incus can potentially cover both Docker and KVM/QEMU use cases
    nftables.enable = (config.virtualisation.incus.enable);
    firewall.trustedInterfaces = if config.virtualisation.incus.enable then [ "incusbr0" ] else [ ];
  };
}
