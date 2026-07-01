{ config, pkgs, ... }:

{
  users.users.kirck = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    interactiveShellInit = ''
      eval "$(starship init zsh)"
    '';
  };

  environment.systemPackages = with pkgs; [
    starship
    chezmoi
    git
  ];

  environment.variables = {
    ZDOTDIR = "$HOME/.config/zsh";
    HISTFILE = "$HOME/.local/state/zsh/history";
    NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
    GOPATH = "$HOME/.local/share/go";
    CARGO_HOME = "$HOME/.local/share/cargo";
    GNUPGHOME = "$HOME/.local/share/gnupg";
  };
}