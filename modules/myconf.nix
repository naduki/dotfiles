{
  # Path to the directory containing flake.nix
  flakeRoot = "/home/share/dotfiles";
  # Hostname
  host = "kokona";
  # Username
  user = "naduki";
  # environments
  environment = [ 
    # "cinnamon"
    "Hyprland"
  ];
  # other settings
  # Enable Podman in Home-manager
  enablePodman = true;
  # Enable Xremap
  enableXremap = false;
}