{
  xdg = {
    enable = true;
    # Ensure user directories use English names instead of localized names
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      download = "$HOME/Downloads";
      templates = "$HOME/Templates";
      publicShare = "$HOME/Public";
      documents = "$HOME/Documents";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
    };
  };
}
