{ config, user, ... }:
let
  # Extract the desktop environment suffix (e.g. "Sway" from "kokona-Sway")
  nhHost = "$(hostname | cut -d- -f2)";
in
{
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/.dotfiles";
  };

  home.shellAliases = {
    # Update flake.lock and auto-commit
    flake-up = "git -C \"$NH_FLAKE\" add -N . && nix flake update --flake \"$NH_FLAKE\" --commit-lock-file";

    # Standard update flow (NixOS boot + Home-manager switch)
    sys-up = "nh os boot -H ${nhHost} && nh home switch -c ${user.name}";

    # NixOS operations
    os-boot = "nh os boot -H ${nhHost}";
    os-test = "nh os test -H ${nhHost}";
    os-build = "nh os build -H ${nhHost}";
    os-vm = "nh os build-vm -H ${nhHost}";
    os-list = "nixos-rebuild list-generations";

    # Home-manager operations
    hm-switch = "nh home switch -c ${user.name}";
    hm-build = "nh home build -c ${user.name}";
    # Reference command for initial standalone activation
    hm-init = "nix run flake:home-manager -- switch --flake \"$NH_FLAKE#${user.name}\"";

    # Garbage collection and boot entry cleanup
    nix-clean = "nh clean all --keep-since 1d && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration boot";
  };
}
