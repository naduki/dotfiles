{ user, ... }:{
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        extraDefCfg = ''
          process-unmapped-keys yes
        '';
        # Capslock: tap -> hiragana/katakana, add ime switch
        #           long press -> Escape
        config = ''
          (defsrc
            caps
          )

          (defalias
            cap (tap-hold 200 200 kana esc)
          )

          (deflayer base
            @cap
          )
        '';
      };
    };
  };

  users.users.${user.name}.extraGroups = [ "uinput" ];
}
