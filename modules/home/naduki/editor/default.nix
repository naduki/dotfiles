{ config, lib, ... }:
{
  options.modules.editors.vscode = {
    variant = lib.mkOption {
      type = lib.types.enum [ "default" "antigravity" ];
      default = "default";
      description = "Switch between default vscode and antigravity configuration";
    };
  };

  imports = [
    ./nvim.nix
    ./vscode.nix
    ./zed-editor.nix
  ];

  config = lib.mkIf (config.programs.micro.enable or false) { home.sessionVariables.EDITOR = "micro"; };
}
