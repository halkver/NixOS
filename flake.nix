{
  description = "System config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nvf = {
      url =  "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-wsl, home-manager, nvf, ... }@inputs:
    let
      system = "x86_64-linux";
      mkSystem = { hostname }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
	    ./hosts/${hostname}/configuration.nix
	    ./common.nix

	    home-manager.nixosModules.default {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.halkver = { 
                imports = [
                  ./home.nix
                  ./hosts/${hostname}/home.nix
                  nvf.homeManagerModules.default
                ];
              };
              home-manager.extraSpecialArgs = { inherit inputs; };
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
