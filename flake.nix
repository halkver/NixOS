{
  description = "System config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-wsl, home-manager, ... }@inputs:
    let
      mkSystem = { hostname }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
	    ./hosts/${hostname}/configuration.nix
	    ./common.nix

	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.halkver = { imports = [ ./home.nix ./hosts/${hostname}/home.nix  ]; };
	    }
          ];
        };
    in {
      nixosConfigurations = {
        wsl = mkSystem { hostname = "wsl"; }; 
        work-wsl = mkSystem { hostname = "work-wsl"; }; 
        work = mkSystem { hostname = "work"; }; 
      };
    };
}
