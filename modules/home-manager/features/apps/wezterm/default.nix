{
  programs.wezterm = {
    enable = true;
    wezterm.extraConfig = builtins.readFile ./wezterm.lua;
  };
}