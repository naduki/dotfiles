{ config, pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev:
      let
        lib = final.lib or prev.lib; # lib を束縛
      in
      {
        catppuccin-fcitx5 =
          let
            pallet = "mocha";
            color = "teal";
            withRoundedCorners = final.withRoundedCorners or prev.withRoundedCorners;
          in
          prev.catppuccin-fcitx5.overrideAttrs (old: {
            installPhase =
              ''
                runHook preInstall
                local variant="catppuccin-${pallet}-${color}"
              ''
              + lib.optionalString withRoundedCorners ''
                find src/$variant -name theme.conf -exec sed -iE 's/^# \(Image=\(panel|highlight\).svg\)/\1/' {} +
              ''
              + ''
                mkdir -p $out/share/fcitx5/themes
                cp -r src/$variant $out/share/fcitx5/themes/$variant
                runHook postInstall
              '';
          });
      })
  ];

  # Japanese input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = (config.programs.hyprland.enable);
      addons = with pkgs; [ fcitx5-mozc catppuccin-fcitx5 ];
    };
  };
}
