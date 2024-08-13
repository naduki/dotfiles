{ inputs, ... }:
{
  imports = [inputs.xremap.nixosModules.default];

  # xremap setting
  services.xremap = {
    userName = "kokona";
    serviceMode = "system";
    config = {
      keymap = [
        {
          name = "Example";
          exact_match = true;
          remap = {
            CapsLock = "Esc"; # IME切り替え
          };
        }
      ];
    };
  };
}
