{ pkgs, ... }:
{
  dconf.settings = {
    # Nemo用の設定
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "wezterm -e --cwd .";
    };
    # "org/cinnamon/desktop/interface" = {
    #   icon-theme = "Mint-Y-Cyan";
    # };
    "org/nemo/preferences" = {
      bulk-rename-tool = "b'${pkgs.bulky}/bin/bulky'";
    };
  };
  # GTK theme configuration
  gtk = {
    enable = true;
    colorScheme = "dark";
    gtk2.enable = false;
    gtk3 = {
      enable = true;
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
