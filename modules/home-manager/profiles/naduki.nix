{ config, pkgs, ... }:
{
  imports = [
    ../../options/unfree.nix

    ../features/apps/wezterm

    ../features/cli/nvim
    ../features/cli/scripts/updater.nix

    ../features/core/programs.nix
    ../features/core/tmpfs.nix
    ../features/core/xdg-user-dirs.nix

    ../features/desktop/sway
    ../features/desktop/fonts.nix
    ../features/desktop/ime.nix
  ];

  unfreePackages = [ "cuda_cudart" "cuda_nvcc" "cuda_cccl" "libcublas" ];

  home = {
    # User Global Aliases
    shellAliases = {
      rmxmod = "find . -type f -exec chmod -x {} +";
      dur = "du --max-depth=1 -h | sort -hr";

      # nix-update = "$HOME/.config/update.sh";

      # xeyes = "nix run nixpkgs#xorg.xeyes";
      # neofetch = "nix run nixpkgs#neofetch";
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
    ollama = {
      enable = true;
      acceleration = "cuda";
    };
    podman = {
      enable = false;
      settings.containers = {
        containers = {
          userns = "keep-id";
        };
      };
    };
  };
}
