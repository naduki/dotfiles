{ pkgs, ... }:
{
  programs = {
    direnv.enableFishIntegration = true;
    fish = {
      enable = true;
    };
    ghostty = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        command = "fish -C 'set fish_greeting' --login";
        theme = "poimandres";
        font-family = [
          "Moralerspace Radon HW"
          "LXGW WenKai Mono"
          "FreeMono"
          "DejaVu Sans Mono"
          "Noto Color Emoji"
          "Noto Emoji"
        ];
        font-size = 15;
      };
      themes = {
        # github:LucidMach/poimandres-ghostty
        poimandres = {
          background = "1b1e28";
          cursor-color = "e4f0fb";
          foreground = "a6accd";
          palette = [
            "0=#1b1e28"
            "1=#d0679d"
            "2=#5de4c7"
            "3=#fffac2"
            "4=#89ddff"
            "5=#d2a6ff"
            "6=#add7ff"
            "7=#ffffff"
            "8=#6c6f93"
            "9=#d0679d"
            "10=#5de4c7"
            "11=#fffac2"
            "12=#89ddff"
            "13=#d2a6ff"
            "14=#add7ff"
            "15=#ffffff"
          ];
          selection-background = "2a2e3f";
          selection-foreground = "f8f8f2";
        };
      };
    };
  };
}
