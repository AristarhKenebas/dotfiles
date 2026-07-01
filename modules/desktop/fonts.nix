{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
    monaspace
    corefonts
  ];

  system.userActivationScripts.copy-fonts-local-share = {
    text = ''
      mkdir -p ~/.local/share/fonts
      cp -u ${pkgs.corefonts}/share/fonts/truetype/* ~/.local/share/fonts/ || true
      chmod 644 ~/.local/share/fonts/* || true
    '';
  };
}