{ pkgs, inputs, ... }:
let
  meltype = pkgs.callPackage ../../../../packages/meltype/fcitx5-meltype.nix {
    src = inputs.meltype;
  };
in {
  nixpkgs.overlays = [
    (final: prev: {
      catppuccin-fcitx5 =
        let
          palette = "mocha";
          color = "teal";
          variant = "catppuccin-${palette}-${color}";
        in
        (prev.catppuccin-fcitx5.override {
          withRoundedCorners = true;
        }).overrideAttrs (old: {
          # Keep only the selected variant (fails if it does not exist)
          postInstall = (old.postInstall or "") + ''
            themes=$out/share/fcitx5/themes
            test -d "$themes/${variant}"
            find "$themes" -mindepth 1 -maxdepth 1 ! -name "${variant}" -exec rm -rf {} +
          '';
        });
    })
  ];

  # Japanese input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        # pkgs.fcitx5-mozc
        pkgs.catppuccin-fcitx5
        meltype
      ];
    };
  };
}
