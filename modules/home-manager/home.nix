{ user, ...}:
{
  imports = [
    ./profiles/${user.name}.nix
  ];

  home = rec {
    username = "${user.name}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;  # Enable home-manager itself
}
