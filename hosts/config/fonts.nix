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
      # emoji, icon fonts
      noto-fonts-monochrome-emoji
      noto-fonts-color-emoji
      material-symbols
      # default fonts
      lxgw-wenkai
      moralerspace-hwnf
    ];
  };
}
