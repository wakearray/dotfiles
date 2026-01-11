{
  description = "WakeNet Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Quickly local nix packages with specific files
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Nix User Packages
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvim configs handled with Nixlang/Flakes
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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

    # Impermanence flake
    impermanence.url = "github:nix-community/impermanence";

    # Declarative disk management using Nixlang/Flakes
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Officially hosted unofficial plugins
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Tui for inspecting a flake
    nix-inspect.url = "github:bluskript/nix-inspect";

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

    # Zen browser, Firefox fork with updated UI
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-index-database, nur, home-manager, system-manager, nix-system-graphics, impermanence, disko, nixvim, sops-nix, simple-nixos-mailserver, nixos-generators, catppuccin, ... }@inputs:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;

    #systems = [
    #  "aarch64-linux"
    #  "x86_64-linux"
    #];

    #forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    inherit lib;
    overlays = import ./overlays {inherit inputs outputs;};

    # Speeds up `nix repl` by using the flake's nixpkgs version
    nix.nixPath = let
      path = toString ./.;
    in
      [ "repl=${path}/repl.nix" "nixpkgs=${inputs.nixpkgs}" ];

    # systemDetails can have a few variables to control what things are installed
    # hostName     = (string of) hostname or home-manager configuration
    # hostType     = (one of) "laptop" "desktop" "server" "android" "kiosk"
    # display      = (one of) "wayland" "x11" "none"
    # features     = (none, one, or more of) "printers" "installer"
    #                "gaming" "minimal" "developer" "gaming" "eink" "einkColor"
    # architecture = (one of) "x86_64-linux" "aarch64-linux"

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      GreatBlue = let
        systemDetails = {
          hostType = "laptop";
          hostName = "GreatBlue";
          display = "wayland";
          features = "printers developer gaming";
          architecture = "x86_64-linux";
        };
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/greatblue/configuration.nix
          nixos-hardware.nixosModules.gpd-win-max-2-2023
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          impermanence.nixosModules.impermanence
          nur.modules.nixos.default
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  ./home/kent/hosts/greatblue
                  nixvim.homeModules.nixvim
                  nur.modules.homeManager.default
                ];
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
            };
          }
        ];
      };
      Starling = let
        systemDetails = {
          hostType = "laptop";
          hostName = "Starling";
          display = "wayland";
          features = "printers developer";
          architecture = "x86_64-linux";
        };
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/starling/configuration.nix
          nixos-hardware.nixosModules.common-cpu-intel
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          impermanence.nixosModules.impermanence
          nur.modules.nixos.default
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
	            users.kent = {
	              imports = [
	                ./home/kent
		              ./home/kent/hosts/starling
                  nixvim.homeModules.nixvim
                  nur.modules.homeManager.default
		            ];
	            };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
            };
          }
        ];
      };
      Moonfish = let
        systemDetails = {
          hostType = "server";
          hostName = "Moonfish";
          display = "cli";
          features = "";
          architecture = "x86_64-linux";
        };
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/moonfish/configuration.nix
          ./modules/servers
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-cpu-amd-zenpower
          nixvim.nixosModules.nixvim
          simple-nixos-mailserver.nixosModule
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  ./home/kent/hosts/moonfish
                  nixvim.homeModules.nixvim
                ];
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
            };
          }
        ];
      };
      # Dell Optiplex 7050 tower
      ## i7-7700 / 32GB DDR4-2300
      Delaware =
      let
        systemDetails = {
          hostType = "server";
          hostName = "Delaware";
          display = "cli";
          features = "";
          architecture = "x86_64-linux";
        };
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          domain = "voicelesscrimson.com";
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/delaware/configuration.nix
          ./modules/servers
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          simple-nixos-mailserver.nixosModule
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "backup";
              users.kent = {
                imports = [
                  ./home/kent
                  ./home/kent/hosts/delaware
                  nixvim.homeModules.nixvim
                ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
            };
          }
        ];
      };
      # Hetzner VPS
      Hamburger =
      let
        systemDetails = {
          hostType = "server";
          hostName = "Hamburger";
          display = "cli";
          features = "minimal";
          architecture = "x86_64-linux";
        };
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          domain = "voicelesscrimson.com";
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/hamburger/configuration.nix
          ./modules/servers
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          simple-nixos-mailserver.nixosModule
          disko.nixosModules.disko
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "backup";
              users.kent = {
                imports = [
                  ./home/kent
                  ./home/kent/hosts/hamburger
                  nixvim.homeModules.nixvim
                ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
            };
          }
        ];
      };
      # Old QNAP NAS
      SebrightBantam = let
        systemDetails = {
          hostType = "server";
          hostName = "SebrightBantam";
          display = "cli";
          features = "minimal";
          architecture = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/sebrightbantam/configuration.nix
          ./modules/servers
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  ./home/kent/hosts/sebrightbantam
                  nixvim.homeModules.nixvim
                ];
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
            };
          }
        ];
      };
      # Cat's projector
      Lagurus = let
        systemDetails = {
          hostType = "kiosk";
          hostName = "Lagurus";
          display = "wayland";
          features = "minimal";
          architecture = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/lagurus/configuration.nix
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  nixvim.homeModules.nixvim
                ];
              };
              users.entertainment = {
                imports = [
                  ./home/entertainment
                  ./home/entertainment/hosts/lagurus
                  nixvim.homeModules.nixvim
                ];
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
            };
          }
        ];
      };
      # TV Computer
      Jerboa = let
        systemDetails = {
          hostType = "kiosk";
          hostName = "Jerboa";
          display = "wayland";
          features = "minimal";
          architecture = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/jerboa/configuration.nix
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.kent = {
                imports = [
                  ./home/kent
                  ./home/kent/hosts/jerboa
                  nixvim.homeModules.nixvim
                ];
              };
              users.entertainment = {
                imports = [
                  ./home/entertainment
                  ./home/entertainment/hosts/jerboa
                  nixvim.homeModules.nixvim
                ];
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
            };
          }
        ];
      };
      # Jess desktop
      Cichlid = let
        systemDetails = {
          hostType = "desktop";
          hostName = "Cichlid";
          display = "wayland";
          features = "printers developer gaming";
          architecture = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/cichlid/configuration.nix
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-hidpi
          nix-index-database.nixosModules.nix-index
	        catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.jess = {
	              imports = [
	                ./home/jess
                  ./home/jess/cichlid
		              catppuccin.homeManagerModules.catppuccin
                  nixvim.homeModules.nixvim
	              ];
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
	          };
          }
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
        ];
      };
      # Jess SteamDeck
      Shoebill = let
        systemDetails = {
          hostType = "laptop";
          hostName = "Shoebill";
          display = "wayland";
          features = "printers gaming";
          architecture = "x86_64-linux";
        };
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
        modules = [
          ./hosts/shoebill/configuration.nix
          nix-index-database.nixosModules.nix-index
	        catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users = {
                jess = {
                  imports = [
                    ./home/jess
                    ./home/jess/hosts/shoebill
                    catppuccin.homeModules.catppuccin
                    nixvim.homeModules.nixvim
                  ];
                };
                kent = {
                  imports = [
                    ./home/kent
                    ./home/kent/hosts/shoebill
                    nixvim.homeModules.nixvim
                  ];
                };
              };
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit inputs outputs;
                systemDetails = systemDetails;
              };
	          };
          }
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          disko.nixosModules.disko
        ];
      };
    };
    # Cichlid liveCD
    # Available through `nix build .#Cichlid`
    Cichlid = let
      systemDetails = {
        hostType = "desktop";
        hostName = "Cichlid";
        display = "wayland";
        features = "printers installer developer gaming";
        architecture = "x86_64-linux";
      };
      in nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs;
        systemDetails = systemDetails;
      };
      modules = [
        ./hosts/cichlid/configuration.nix
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-ssd
        nixos-hardware.nixosModules.common-hidpi
        nix-index-database.nixosModules.nix-index
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            users.jess = {
              imports = [
                ./home/jess
                ./home/jess/hosts/cichlid
                catppuccin.homeManagerModules.catppuccin
                nixvim.homeModules.nixvim
              ];
            };
            users.kent = {
              imports = [
                ./home/kent
                ./home/kent/hosts/cichlid
                nixvim.homeModules.nixvim
              ];
            };
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit inputs outputs;
              systemDetails = systemDetails;
            };
          };
        }
        nixvim.nixosModules.nixvim
        sops-nix.nixosModules.sops
      ];
      format = "iso";
      # https://github.com/nix-community/nixos-generators#using-in-a-flake
    };
    # CustomInstaller liveCD
    # Available through `nix build .#CustomInstaller`
    CustomInstaller = let
      systemDetails = {
        hostType = "server";
        hostName = "CustomInstaller";
        display = "cli";
        features = "installer minimal";
        architecture = "x86_64-linux";
      };
      in nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs;
        systemDetails = systemDetails;
      };
      modules = [
        ./hosts/custominstaller/configuration.nix
        nix-index-database.nixosModules.nix-index
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            users.kent = {
              imports = [
                ./home/kent
                nixvim.homeModules.nixvim
              ];
            };
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit inputs outputs;
              systemDetails = systemDetails;
            };
          };
        }
        nixvim.nixosModules.nixvim
        sops-nix.nixosModules.sops
      ];
      format = "iso";
      # https://github.com/nix-community/nixos-generators#using-in-a-flake
    };

    # Non-NixOS System Configuration
    # nix run 'github:numtide/system-manager' -- switch --flake '.#android'
    systemConfigs.android = system-manager.lib.makeSystemConfig {
      modules = [
        ./modules/system-manager
        # nix-system-graphics makes normal NixOS graphics packages (mesa by default)
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
        systemDetails = {
          hostType = "android";
          hostName = "kent@android";
          display = "x11";
          features = "developer";
          architecture = "aarch64-linux";
        };
      in lib.homeManagerConfiguration {
        modules = [
          ./home/kent
          nixvim.homeModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
      };
      "kent@y700" = let
        systemDetails = {
          hostType = "android";
          hostName = "kent@y700";
          display = "x11";
          features = "developer";
          architecture = "aarch64-linux";
        };
      in lib.homeManagerConfiguration {
        modules = [
          ./home/kent
          ./home/kent/hosts/y700
          nixvim.homeModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
      };
      # Jess' Boox Tab Ultra C Pro
      "jess@toucan" = let
        systemDetails = {
          hostType = "android";
          hostName = "jess@toucan";
          display = "x11";
          features = "eink developer";
          architecture = "aarch64-linux";
        };
      in lib.homeManagerConfiguration {
        modules = [
          ./home/jess
          ./home/jess/hosts/toucan
          nixvim.homeModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          systemDetails = systemDetails;
        };
      };
    };
  };
}
