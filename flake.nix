{
  description = "WakeNet Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix User Packages
    nur.url = "github:nix-community/NUR";

    # Lix - A modern Rust based nix alternative
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvim configs handled with Nixlang/Flakes
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-darwin.follows = "";
      };
    };

    # Manage you dotfiles and local apps with Nixlang/Flakes
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manage your systemd and /etc files on non NixOS Linux distros using Nixlang/Flakes
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Make NixOS graphics drivers available to home-manager installed programs on non NixOS systems
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk management using Nixlang/Flakes
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland + Plugins
    hyprland.url = "github:hyprwm/Hyprland/v0.45.2";
    ## Official plugins
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    ## Officially hosted unofficial plugins
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## hyprland touch screen dispachers
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };
    ## Additional hyprland multimonitor support
    hyprsplit = {
      url = "github:shezdy/hyprsplit/v0.45.2";
      inputs.hyprland.follows = "hyprland";
    };
    ## Workspace overview feature for hyprland
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative mailserver configured in Nixlang
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
    };

    # Build ISOs, VM images, and more using Nixlang/Flakes
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Catppuccin theming for home-manager
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, nur, lix-module, home-manager, system-manager, nix-system-graphics, nixvim, sops-nix, simple-nixos-mailserver, nixos-generators, catppuccin, ... }@inputs:
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

    # Special args can have a few variables to control what things are installed
    # host-type      = (one of) "laptop" "desktop" "server" "android" "kiosk"
    # display-type   = (one of) "wayland" "x11" "none"
    # host-options   = (one or more of) "printers" "installer" "eink"
    # current-system = (one of) "x86_64-linux" "aarch64-linux"

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      GreatBlue = let
        system-details = {
          host-type = "laptop";
          host-name = "GreatBlue";
          display-type = "wayland";
          host-options = "printers";
          current-system = "x86_64-linux";
        };
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          system-details = system-details;
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
                  ./home/kent/hosts/greatblue
                  nixvim.homeManagerModules.nixvim
                ];
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                system-details = system-details;
              };
            };
          }
        ];
      };
      # Dell Optiplex 7050 tower
      ## i7-7700 / 32GB DDR4-2300
      Delaware =
      let
        system-details = {
          host-type = "server";
          host-name = "Delaware";
          display-type = "none";
          host-options = "printers";
          current-system = "x86_64-linux";
        };
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          domain = "voicelesscrimson.com";
          system-details = system-details;
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
              backupFileExtension = "backup";
              users.kent = {
                imports = [
                  ./home/kent
                  ./home/kent/hosts/delaware
                  nixvim.homeManagerModules.nixvim
                ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                system-details = system-details;
              };
            };
          }
        ];
      };
      # Old QNAP NAS
      SebrightBantam = let
        system-details = {
          host-type = "server";
          host-name = "SebrightBantam";
          display-type = "none";
          host-options = "";
          current-system = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          system-details = system-details;
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
                  ./home/kent/hosts/sebrightbantam
                  nixvim.homeManagerModules.nixvim
                ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                system-details = system-details;
              };
            };
          }
        ];
      };
      # Cat's projector
      Lagurus = let
        system-details = {
          host-type = "kiosk";
          host-name = "Lagurus";
          display-type = "wayland";
          host-options = "";
          current-system = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          system-details = system-details;
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
                  ./home/entertainment
                  ./home/entertainment/hosts/lagurus
                  nixvim.homeManagerModules.nixvim
                ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                system-details = system-details;
              };
            };
          }
        ];
      };
      # Jess desktop
      Cichlid = let
        system-details = {
          host-type = "desktop";
          host-name = "Cichlid";
          display-type = "wayland";
          host-options = "printers";
          current-system = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          system-details = system-details;
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
                  ./home/jess/cichlid
		              catppuccin.homeManagerModules.catppuccin
	              ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                system-details = system-details;
              };
	          };
          }
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          lix-module.nixosModules.default
        ];
      };
      # Jess SteamDeck
      Shoebill = let
        system-details = {
          host-type = "laptop";
          host-name = "Shoebill";
          display-type = "wayland";
          host-options = "printers";
          current-system = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          system-details = system-details;
        };
        modules = [
          ./hosts/shoebill/configuration.nix
	        catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jess = {
	              imports = [
	                ./home/jess
                  ./home/jess/shoebill
		              catppuccin.homeManagerModules.catppuccin
	              ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                system-details = system-details;
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
    Cichlid = let
      system-details = {
        host-type = "desktop";
        host-name = "Cichlid";
        display-type = "wayland";
        host-options = "printers installer";
        current-system = "x86_64-linux";
      };
      in nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs;
        secrets = "/etc/nixos/secrets";
        system-details = system-details;
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
            extraSpecialArgs = {
              inherit inputs outputs;
              system-details = system-details;
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
    # nix run 'github:numtide/system-manager' -- switch --flake '.#android'
    systemConfigs.android = system-manager.lib.makeSystemConfig {
      modules = [
        ./system-manager
        # nix-system-graphics makes normal NixOS graphics packages
        # available to non NixOS systems
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
    # Available through `home-manager --flake .#user@host`
    # or `nh home switch -c user@host` if nh is available
    homeConfigurations = {
      # General Android configuration
      "kent@android" = let
        system-details = {
          host-type = "android";
          host-name = "kent@android";
          display-type = "x11";
          host-options = "";
          current-system = "aarch64-linux";
        };
      in lib.homeManagerConfiguration {
        modules = [
          ./home/kent
          ./home/kent/hosts/android
          nixvim.homeManagerModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          system-details = system-details;
        };
      };
      # Jess' Boox Tab Ultra C Pro
      "jess@toucan" = let
        system-details = {
          host-type = "android";
          host-name = "jess@toucan";
          display-type = "x11";
          host-options = "eink";
          current-system = "aarch64-linux";
        };
      in lib.homeManagerConfiguration {
        modules = [
          ./home/jess
          ./home/jess/hosts/toucan
          nixvim.homeManagerModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          system-details = system-details;
        };
      };
    };
  };
}
