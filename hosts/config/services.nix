{
  services = {
    # X11 settings
    xserver = {
      # GPU Driver
      videoDrivers = [ "nvidia" ];
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
