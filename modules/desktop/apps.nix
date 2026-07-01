{ pkgs, pkgs-unstable, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Мессенджеры и соцсети
    telegram-desktop 
    discord 
    
    # Творчество и работа
    krita 
    penpot-desktop 
    kdePackages.kdenlive 
    blockbench 
    onlyoffice-desktopeditors
    
    # Разработка
    vscode
    pkgs-unstable.zed-editor
    pkgs-unstable.neovim
    pkgs-unstable.inkscape

    # Браузер
    inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin
  ];
}