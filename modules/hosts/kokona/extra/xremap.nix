{ inputs, myconf, ... }:
{
  imports = [ inputs.xremap.nixosModules.default ];
  # xremap setting
  services.xremap = {
    userName = "${myconf.host}";
    serviceMode = "system";
    config = {
      keymap = [
        {
          name = "Example";
          exact_match = true;
          remap = {
            CapsLock = "Esc";
          };
        }
      ];
    };
  };
}
