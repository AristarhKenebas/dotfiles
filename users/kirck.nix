{ config, pkgs, ... }:

{
  users.users.kirck = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
  };

  programs.zsh = {
    enable = true;
    
    enableCompletion = false; 
    
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    
    histFile = "$HOME/.local/state/zsh/history";

    promptInit = "";

    interactiveShellInit = ''
      mkdir -p $HOME/.cache/zsh
      autoload -U compinit
      compinit -d $HOME/.cache/zsh/zcompdump-$ZSH_VERSION

      eval "$(starship init zsh)"
    '';
  };
  environment.systemPackages = with pkgs; [
    starship
    chezmoi
    git
  ];

  system.userActivationScripts.zsh-history-dir = {
    text = ''
      mkdir -p ~/.local/state/zsh
    '';
  };
}