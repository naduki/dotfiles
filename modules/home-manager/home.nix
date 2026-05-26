{
  imports = [
    ./profiles/naduki.nix
  ];

  home = rec {
    username = "naduki";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;  # Enable home-manager itself
}
