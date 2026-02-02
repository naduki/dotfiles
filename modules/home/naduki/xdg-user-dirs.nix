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
    desktopEntries = {
      "blueman-adapters" = {
        name = "Bluetooth Adapters";
        noDisplay = true;
      };
      "kbd-layout-viewer5" = {
        name = "Keyboard Layout Viewer";
        noDisplay = true;
      };
      "org.fcitx.fcitx5-migrator" = {
        name = "Fcitx 5 Migration Wizard";
        noDisplay = true;
      };
    };
  };
}
