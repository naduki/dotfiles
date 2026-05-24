{ myconf, ... }:
{
  imports = [
    ./${myconf.user}
  ];

  home = rec {
    username = "${myconf.user}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };
  programs.home-manager.enable = true;  # Enable home-manager itself
}
