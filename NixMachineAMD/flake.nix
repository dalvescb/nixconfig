{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        NixMachineAMD = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix
                      home-manager.nixosModules.home-manager {
                        home-manager.userGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.dalvescb = {
                          imports = [ /home/dalvescb/nixconfig/home.nix ];
                        };
                      }
                    ];
        };

        hmConfig = {
          dalvescb =
            home-manager.lib.homeManagerConfiguration {
              inherit system pkgs;
              username = "dalvescb";
              homeDirectory = "/home/dalvescb";

              configuration = {
                imports = [
                  /home/dalvescb/nixconfig/home.nix
                ];
              };
            };
        };
      };
    };
}
