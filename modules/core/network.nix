{
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

  services.tailscale.enable = true;
  services.v2raya.enable = true;
}