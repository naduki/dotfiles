{
  services = {
    # X11 settings
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      # GPU Driver
      videoDrivers = [ "nvidia" ];
      # Enable the Cinnamon Desktop Environment.
      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    # File system trim
    fstrim.enable = true;
    # Disable CUPS to print documents.
    printing.enable = false;
    # Enable sound with pipewire.
    pulseaudio.enable = false;
  };
}