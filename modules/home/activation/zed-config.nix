{ config, lib, myconf, ... }:
{
  # Create a symbolic link for Zed Global Setting (Because it must be able to be rewritten with AI settings)
  config = lib.mkIf (config.programs.zed-editor.enable or false) {
    home.activation.makeZedSymbolic =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run ln -fns ${myconf.flakeRoot}/config/zed/settings.json ${config.home.homeDirectory}/.config/zed/settings.json
      '';
  };
}
