{
  description = "Kirck's Multi-Host NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";    
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
  };

  outputs = { self, nixpkgs, ... } @ inputs: 
  let
    system = "x86_64-linux";
    
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system; 
      config.allowUnfree = true;
    };

    baseArgs = { inherit inputs pkgs-unstable system; };
  in {
    nixosConfigurations = {
      
      thinkbook = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = baseArgs;
        modules = [ 
          ./hosts/thinkbook/default.nix 
        ];
      };

    };
  };
}