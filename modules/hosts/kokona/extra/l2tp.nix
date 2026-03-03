{ pkgs, ... }:
{
  # Enable L2TP VPN
  networking.networkmanager.plugins = [ pkgs.networkmanager-l2tp ];

  services.strongswan = {
    # Enable strongSwan itself
    enable = true;
    # Recognize the secret path for the L2TP plugin
    secrets = [ "ipsec.d/ipsec.nm-l2tp.secrets" ];
  };

  # Add a dummy configuration to prevent errors caused by missing /etc/strongswan.conf
  environment.etc."strongswan.conf".text = "";
}