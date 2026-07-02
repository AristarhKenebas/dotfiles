{
  description = "Kirck's Multi-Host NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";    
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
    nix-gaming.url = "github:fufexan/nix-gaming";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: 
  let
    system = "x86_64-linux";
    
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system; 
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      thinkbook = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-unstable; };
        modules = [ 
          ./hosts/thinkbook/default.nix 
        ];
      };
    };
  };
}