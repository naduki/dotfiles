{ lib, myconf, ... }: {
  imports = [
    ./fonts.nix
    ./ime.nix
    ./limine.nix
    ./locale_jp.nix
    ./nvidia.nix
    ./extra/security.nix
    ./sound.nix
    ./system.nix
    ./virtualisation.nix
  ]
  ++ lib.optional (builtins.elem "Cinnamon" (myconf.environment or [ ])) ./desktop/cinnamon.nix
  ++ lib.optional (builtins.elem "Sway" (myconf.environment or [ ])) ./desktop/sway.nix
  ++ lib.optional (builtins.elem "Hyprland" (myconf.environment or [ ])) ./desktop/hyprland.nix;
}
