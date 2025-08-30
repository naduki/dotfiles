{
  # Initial setup mode
  # When set to true, Blender CUDA and Steam will not be installed.
  naduki_initialSetup = false;
  # Path to the directory containing flake.nix
  flakeRoot = "/home/share/dotfiles";
  # Hostname  "kokona"
  host = "kokona";
  # Username  "naduki"
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