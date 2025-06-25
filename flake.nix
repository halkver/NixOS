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
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
	    ./wsl/configuration.nix 
	    ./common.nix
	    nixos-wsl.nixosModules.default
	    home-manager.nixosModules.default
          ];
        };

        work = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
	    ./work/configuration.nix 
	    ./common.nix
	    home-manager.nixosModules.default
	  ];
        };
      };

      homeConfigurations.halkver = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
	extraSpecialArgs = { inherit inputs; };
	modules = [ ./home.nix ];
      };
    };
}
