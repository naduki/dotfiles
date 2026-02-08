{ pkgs, ... }:
{
  programs.helix.extraPackages = with pkgs; [
    bash-language-server
    clang-tools
    nixd
    nixfmt
    shellcheck-minimal
    lldb
  ];
}