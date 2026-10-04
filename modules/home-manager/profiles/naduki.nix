{ config, pkgs, ... }:
{
  imports = [
    ../../options/unfree.nix

    ../features/apps/wezterm
    ../features/apps/wine

    ../features/cli/nvim
    ../features/cli/scripts/updater.nix

    ../features/core/programs.nix
    ../features/core/tmpfs.nix
    ../features/core/xdg-user-dirs.nix

    ../features/desktop/sway
    ../features/desktop/fonts.nix
    ../features/desktop/ime.nix
  ];

  home = {
    # User Global Aliases
    shellAliases = {
      rmxmod = "find . -type f -exec chmod -x {} +";
      dur = "du --max-depth=1 -h | sort -hr";
      # xeyes = "nix run nixpkgs#xorg.xeyes";
    };
  };

  # Disable home-manager news notifications on switch
  news.display = "silent";

  programs = {
    fish = {
      enable = true;
      functions = {
        fish_greeting = "echo";
      };
    };
    chromium = {
      enable = true;
      package = pkgs.brave;
    };
    direnv = {
      enableFishIntegration = (config.programs.fish.enable);
    };
    git = {
      settings = {
        init.defaultBranch = "main";
        user = {
          name = "naduki";
          email = "68984205+naduki@users.noreply.github.com";
        };
      };
      signing = {
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
      };
    };
  };

  services = {
    podman = {
      enable = true;
      settings.containers = {
        containers = {
          userns = "keep-id";
        };
      };
    };
  };
}
