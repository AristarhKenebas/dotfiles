{ pkgs, inputs, ... }@args:

let
  pkgs-unstable = args.pkgs-unstable or pkgs;
in
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
    # Wayland utilities and tools
    foot 
    fastfetch 
    brightnessctl 
    yazi 
    playerctl 
    xdg-utils 
    cliphist 
    wl-clipboard
    waybar 
    hyprlock 
    hypridle 
    wlogout 
    hyprshot 
    swappy 
    wofi 
    wf-recorder 
    slurp
    swayosd 
    hyprpolkitagent 
    hyprlauncher 
    swaynotificationcenter 
    libnotify
    pyprland 
    awww

    # Graphical system utilities
    nautilus 
    wireplumber 
    pavucontrol 
    oculante 
    clapper
    
    # Gaming and compatibility tools
    wineWow64Packages.stable 
    winetricks

    # Development tools
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}