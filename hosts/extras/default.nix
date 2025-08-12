{
  imports = [
    ./security.nix
    # ./virtualisation.nix
    # ./xremap.nix
  ];

  system.rebuild.enableNg = true; # Enable NixOS rebuildng command

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048;
      cores = 2;
    };         
  };
}
