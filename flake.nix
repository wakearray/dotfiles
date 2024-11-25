{
  description = "WakeNet Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur.url = "github:nix-community/NUR";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-darwin.follows = "";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, nur, lix-module, home-manager, system-manager, nix-system-graphics, nixvim, sops-nix, simple-nixos-mailserver, nixos-generators, catppuccin, ... }@inputs:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;

    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    inherit lib;
    #nixosModules = import ./modules/nixos;
    #homeManagerModules = import ./modules/home-manager;
    overlays = import ./overlays {inherit inputs outputs;};
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      GreatBlue = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
        };
        modules = [
          ./hosts/greatblue/configuration.nix
          nixos-hardware.nixosModules.gpd-win-max-2-2023
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  nixvim.homeManagerModules.nixvim
                ];
              };
            };
          }
        ];
      };
      Delaware = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          domain = "voicelesscrimson.com";
        };
        modules = [
          ./hosts/delaware/configuration.nix
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          simple-nixos-mailserver.nixosModule
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  nixvim.homeManagerModules.nixvim
                ];
              };
            };
          }
        ];
      };
      SebrightBantam = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
        };
        modules = [
          ./hosts/sebrightbantam/configuration.nix
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  nixvim.homeManagerModules.nixvim
                ];
              };
            };
          }
        ];
      };
      Lagurus = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./hosts/lagurus/configuration.nix
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  nixvim.homeManagerModules.nixvim
                ];
              };
            };
          }
        ];
      };
      Cichlid = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
        };
        modules = [
          ./hosts/cichlid/configuration.nix
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-hidpi
	        catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jess = {
	              imports = [
	                ./home/jess
		              catppuccin.homeManagerModules.catppuccin
	              ];
              };
	          };
          }
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          lix-module.nixosModules.default
        ];
      };
    };
    # Cichlid liveCD
    # Available through `nix build .#Cichlid`
    Cichlid = nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs;
        secrets = "/etc/nixos/secrets";
      };
      modules = [
        ./hosts/cichlid/configuration.nix
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-hidpi
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jess = {
              imports = [
                ./home/jess
                catppuccin.homeManagerModules.catppuccin
              ];
            };
          };
        }
        nixvim.nixosModules.nixvim
        sops-nix.nixosModules.sops
        lix-module.nixosModules.default
      ];
      format = "iso";
      # https://github.com/nix-community/nixos-generators#using-in-a-flake
    };

    # Non-NixOS System Configuration
    # nix run 'github:numtide/system-manager' -- switch --flake '.#mobile'
    systemConfigs.mobile = system-manager.lib.makeSystemConfig {
      modules = [
        nix-system-graphics.systemModules.default
        {
          config = {
            nixpkgs.hostPlatform = "aarch64-linux";
            system-manager.allowAnyDistro = true;
            system-graphics.enable = true;
          };
        }
      ];
    };

    # Standalone home-manager configuration entrypoint
    # Available through `home-manager --flake .#your-username@your-hostname`
    # or `nh home switch -c kent@mobile` if nh is available
    homeConfigurations = {
      "kent@mobile" = lib.homeManagerConfiguration {
        modules = [
          ./home/kent
          ./home/kent/mobile
          nixvim.homeManagerModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
