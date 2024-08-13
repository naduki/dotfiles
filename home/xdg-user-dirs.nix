{
  xdg = {
    enable = true;
    # ディレクトリ名が日本語にならないようにする
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
