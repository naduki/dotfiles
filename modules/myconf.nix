{
  # Relative path (from /home/$USER) to the directory containing flake.nix
  flakeRoot = ".config/.dotfiles";
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
  enablePodman = false;
  # Enable Xremap
  enableXremap = false;
}