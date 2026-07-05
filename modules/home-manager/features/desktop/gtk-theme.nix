{ pkgs, ... }:
{
  # GTK theme configuration
  gtk = {
    enable = true;
    gtk2.enable = false;
    gtk3 = {
      enable = true;
      # cursorTheme is managed by home.pointerCursor in sway-settings.nix
      iconTheme = {
        name = "Mint-Y-Cyan";
        package = pkgs.mint-y-icons;
      };
      theme = {
        name = "Colloid-Teal-Dark";
        package = pkgs.colloid-gtk-theme.override {
          colorVariants = [ "dark" ];
          themeVariants = [ "teal" ];
        };
      };
    };
    gtk4.enable = false;
  };
}
