{ pkgs, pkgs-unstable, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Messaging and communication
    telegram-desktop 
    discord 
    
    # Graphics and design
    krita 
    penpot-desktop 
    kdePackages.kdenlive 
    blockbench 
    onlyoffice-desktopeditors
    
    # Development
    vscode
    pkgs-unstable.zed-editor
    pkgs-unstable.neovim
    pkgs-unstable.inkscape

    # Browser
    inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin
  ];
}