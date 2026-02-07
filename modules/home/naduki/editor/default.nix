{ config, lib, ... }:
{
  options.modules.editors.vscode = {
    variant = lib.mkOption {
      type = lib.types.enum [ "vscode" "vscodium" "antigravity" ];
      default = "vscode";
      description = "Switch between default vscode and antigravity configuration";
    };
  };

  imports = [
    ./nvim.nix
    ./vscode
    ./zed-editor.nix
  ];
}
