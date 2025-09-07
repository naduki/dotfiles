{ config, lib, ... }:
{
  imports = [
    ./nvim.nix
    ./vscode.nix
    ./zed-editor.nix
  ];

  config = lib.mkIf (config.programs.micro.enable or false) { home.sessionVariables.EDITOR = "micro"; };
}
