{
  # /home/$USERからのflake.nixがあるディレクトリの相対パス
  flakeRoot = ".config/.dotfiles";
  # Username
  user = "naduki";
  # Hostname
  host = "kokona";
  # environments
  environment = [ 
    # "cinnamon"
    "Hyprland"
    # "wsl"
  ];
  # other settings
  xremap = false;
}