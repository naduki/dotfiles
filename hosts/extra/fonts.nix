{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts-cjk-serif

      noto-fonts-emoji
      material-design-icons

      # Moralerspace
      "${pkgs.fetchzip {
            url = "https://github.com/yuru7/moralerspace/releases/download/v1.0.2/MoralerspaceHWNF_v1.0.2.zip";
            sha256 = "sha256-9jbOELf/kBMVZMPPEAZ/1ubqxNZ+6oHFoOKrG9srQkE=";
        }}"
        # Klee One, Zen Kurenaido, Fabric External MDL2 Assetsは$HOME/.local/share/fontsに手動で配置
    ];
    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;
    fontconfig = {
      enable = true;
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
            <!-- Japanese (ja) -->
            <match target="pattern">
                <test qual="any" name="family">
                    <string>serif</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                    <string>Klee One</string>
                    <string>Zen Kurenaido</string>
                    <string>Noto Serif CJK JP</string>
                </edit>
            </match>

            <match target="pattern">
                <test qual="any" name="family">
                    <string>sans-serif</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                    <string>Klee One</string>
                    <string>Fabric External MDL2 Assets</string>
                    <string>Zen Kurenaido</string>
                </edit>
            </match>

            <match target="pattern">
                <test qual="any" name="family">
                    <string>monospace</string>
                </test>
                <edit name="family" mode="prepend" binding="strong">
                    <string>Moralerspace Radon HWNF</string>
                </edit>
            </match>
            <!-- Japanese (ja) ends -->
        </fontconfig>
      '';
    };
  };
}
