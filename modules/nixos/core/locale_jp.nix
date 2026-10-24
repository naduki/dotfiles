{
  i18n = {
    # Select internationalisation properties.
    # (LC_* categories fall back to this, so extraLocaleSettings is not needed)
    defaultLocale = "ja_JP.UTF-8";
  };
  # Set your time zone.
  time.timeZone = "Asia/Tokyo";
  networking.timeServers = [ "ntp.nict.jp" ];
}
