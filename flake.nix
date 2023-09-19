{
  description = "NixOS Configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = { self, nixpkgs, home-manager, nix-doom-emacs, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;

      doom-emacs = nix-doom-emacs.packages.${system}.default.override {
        doomPrivateDir = ./doom.d;
      };

    in {
      nixosConfigurations = {
        NixMachine = lib.nixosSystem {
          inherit system;
          modules = [ ./NixMachine/configuration.nix
                      home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.dalvescb = {
                          imports = [ ./home.nix ];
                        };
                      }
                    ];
          specialArgs.flake-inputs = inputs // { inherit doom-emacs;  };
        };
       # hmConfig is not necessary? Replaced with declaration in nixosConfigurations.NixMachine.modules?
        hmConfig = {
          dalvescb =
            home-manager.lib.homeManagerConfiguration {
              inherit system pkgs;
              username = "dalvescb";
              homeDirectory = "/home/dalvescb";

              configuration = {
                imports = [
                  ./home.nix
                ];
              };
            };
        };
      };
    };
}
