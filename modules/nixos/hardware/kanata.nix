{ user, ... }:{
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        extraDefCfg = ''
          process-unmapped-keys yes
        '';
        # Capslock: tap -> Escape, (for Neovim)
        #           long press -> Mod (for Sway)
        config = ''
          (defsrc
            caps
          )

          (defalias
            cap (tap-hold 200 200 esc lmet)
          )

          (deflayer base
            @cap
          )
        '';
      };
    };
  };

  # users.users.${user.name}.extraGroups = [ "uinput" ];
}
