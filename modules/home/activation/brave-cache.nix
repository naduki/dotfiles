{ config, lib, ... }:
{
  # Create a symbolic link for Brave Cache Directory
  config = lib.mkIf ((lib.strings.toLower (config.programs.chromium.package.pname or "")) == "brave") {
    home.activation.makeBraveSymbolic = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -fns /tmp ${config.home.homeDirectory}/.cache/BraveSoftware
    '';
  };
}
