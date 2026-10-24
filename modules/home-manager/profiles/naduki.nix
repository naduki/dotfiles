{ config, pkgs, ... }:
{
  imports = [
    ../../options/nixpkgs.nix

    ../features/apps/wezterm
    ../features/apps/wine

    ../features/cli/agy
    ../features/cli/nh
    ../features/cli/nvim

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
      gan = "git add -N .";
      dur = "du --max-depth=1 -h | sort -hr";
      rmxmod = "find . -type f -exec chmod -x {} +";
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
