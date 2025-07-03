{
  description = "System config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixCats.url = "github:BirdeeHub/nixCats-nvim"; 
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fzf-preview = {
      url = "github:niksingh710/fzf-preview";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      mkSystem =
        { hostname }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./common.nix

            home-manager.nixosModules.default
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.halkver = {
                  imports = [
                    ./home.nix
                    ./hosts/${hostname}/home.nix
                  ];
                };
              };
            }
          ];
        };
      python = pkgs.python313;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ python pkgs.uv ];
        env = { UV_PYTHON_DOWNLOADS = "never"; UV_PYTHON = python.interpreter; }
        // nixpkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
          LD_LIBRARY_PATH = nixpkgs.lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
        };
        shellHook = ''
          unset PYTHONPATH
        '';
      };

      nixosConfigurations = {
        wsl = mkSystem { hostname = "wsl"; };
        work-wsl = mkSystem { hostname = "work-wsl"; };
        work = mkSystem { hostname = "work"; };
      };
    };
}
