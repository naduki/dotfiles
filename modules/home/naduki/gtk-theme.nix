{ pkgs-stable, ... }:
{
  # GTK theme configuration
  gtk = {
    enable = true;
    cursorTheme = {
      name = "catppuccin-mocha-teal-cursors";
      package = pkgs-stable.catppuccin-cursors.mochaTeal;
    };
    iconTheme = {
      name = "Mint-Y-Cyan";
      package = pkgs-stable.mint-y-icons;
    };
    theme = {
      name = "Colloid-Teal-Dark";
      package = pkgs-stable.colloid-gtk-theme.override {
        colorVariants = [ "dark" ];
        themeVariants = [ "teal" ];
      };
    };
  };
}