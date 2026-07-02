{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core/system.nix
    ../../modules/core/network.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/apps.nix
    ../../modules/programs/steam.nix
    ../../modules/core/clean-home.nix
    ../../modules/core/security.nix
    ../../users/kirck.nix
  ];

  networking.hostName = "thinkbook";
  system.stateVersion = "26.05";

  environment.systemPackages = with pkgs; [
    git wget fd ripgrep p7zip unzip zip jq lsof micro
  ];
}