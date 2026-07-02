{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ xray ];

  services.xray = {
    enable = true;
    settingsFile = "/etc/xray/config.json"; 
  };

  boot.kernelModules = [ "tun" ];
}