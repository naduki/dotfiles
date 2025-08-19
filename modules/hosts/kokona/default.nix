{ lib, myconf, ...}:{
  imports = [
    ./fonts.nix
    ./ime.nix
    ./limine_amd.nix
    ./locale_jp.nix
    ./nvidia.nix
    ./extra/security.nix
    ./sound.nix
    ./system.nix
    ./virtualisation.nix
  ]
    ++ lib.optional (lib.lists.elem "cinnamon" (myconf.environment or [])) ./desktop/cinnamon.nix
    ++ lib.optional (lib.lists.elem "Hyprland" (myconf.environment or [])) ./desktop/hyprland.nix
    # ++ lib.optional (myconf.xremap) ./extra/xremap.nix
  ;
}