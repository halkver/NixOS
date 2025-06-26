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
	    ./hosts/wsl/configuration.nix
	    ./common.nix
	    nixos-wsl.nixosModules.default
          ];
        };

        work-wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
	    ./hosts/work/wsl-configuration.nix
	    ./common.nix
	    nixos-wsl.nixosModules.default
          ];
        };

        work = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
	    ./hosts/work/desktop-configuration.nix
	    ./common.nix
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
