{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    packages = with pkgs; [
      # fallback fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      dejavu_fonts
      # emoji, icon fonts
      noto-fonts-monochrome-emoji
      noto-fonts-color-emoji
      material-symbols
      freefont_ttf
      # default fonts
      lxgw-wenkai
      moralerspace-hw
      (google-fonts.override {
        fonts = [
          "Klee One"
        ];
      })
    ];
  };
}
