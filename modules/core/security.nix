{
  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    
    allowPing = false;

    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    
    filterForward = false;
  };

  boot.kernel.sysctl = {
    # Security from SYN-flood (basic method of DDoS attacks)
    "net.ipv4.tcp_syncookies" = 1;

    # Protection from IP-spoofing (address manipulation)
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;

    # Ignore ICMP redirects (protection from Man-in-the-Middle attacks in public Wi-Fi)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;

    # Disallow routing from sources (another attack vector)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
  };
}