{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts-cjk-serif

      noto-fonts-emoji
      material-design-icons

      moralerspace-hwnf
    ];
  };
}
