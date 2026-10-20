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
          pallet = "mocha";
          color = "teal";
          variant = "catppuccin-${pallet}-${color}";
        in
        (prev.catppuccin-fcitx5.override {
          withRoundedCorners = true;
        }).overrideAttrs (old: {
          installPhase = builtins.replaceStrings
            [
              "mkdir -p $out/share/fcitx5"
              "cp -r src $out/share/fcitx5/themes"
            ]
            [
              "mkdir -p $out/share/fcitx5/themes"
              "cp -r src/${variant} $out/share/fcitx5/themes/${variant}"
            ]
            old.installPhase;
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
