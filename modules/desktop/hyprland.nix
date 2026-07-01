{ pkgs, pkgs-unstable, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = pkgs-unstable.hyprland;
  };

  hardware.graphics.enable = true;

  environment.variables.TERMINAL = "foot";

  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    # Терминал и системные утилиты Wayland
    foot fastfetch brightnessctl yazi playerctl xdg-utils cliphist wl-clipboard
    waybar hyprlock hypridle wlogout hyprshot swappy wofi wf-recorder slurp
    swayosd hyprpolkitagent hyprlauncher swaynotificationcenter libnotify
    pyprland awww

    # Графические системные утилиты
    nautilus wireplumber pavucontrol oculante clapper
  ];
}