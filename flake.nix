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

    # Special args can have a few variables to control what things are installed
    # host-type = (one of) "laptop" "desktop" "server" "android" "kiosk"
    # display-type = (one of) "wayland" "x11" "none"
    # host-options = (one or more of) "printers" "installer" "eink"
    # current-system = (one of) "x86_64-linux" "aarch64-linux"

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      GreatBlue = let
        host-type = "laptop";
        display-type = "wayland";
        host-options = "printers";
        current-system = "x86_64-linux";
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          host-type = host-type;
          display-type = display-type;
          host-options = host-options;
          current-system = current-system;
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
                  ./home/kent/greatblue
                  nixvim.homeManagerModules.nixvim
                ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                host-type = host-type;
                display-type = display-type;
                host-options = host-options;
                current-system = current-system;
              };
            };
          }
        ];
      };
      Delaware =
      let
        host-type = "server";
        display-type = "none";
        host-options = "printers";
        current-system = "x86_64-linux";
      in
      lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          domain = "voicelesscrimson.com";
          host-type = host-type;
          display-type = display-type;
          host-options = host-options;
          current-system = current-system;
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
                  ./home/kent/delaware
                  nixvim.homeManagerModules.nixvim
                ];
              };
              extraSpecialArgs = {
                inherit inputs outputs;
                host-type = host-type;
                display-type = display-type;
                host-options = host-options;
                current-system = current-system;
              };
            };
          }
        ];
      };
      # Old QNAP NAS
      SebrightBantam = let
        host-type = "server";
        display-type = "none";
        host-options = "";
        current-system = "x86_64-linux";
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          host-type = "server";
          display-type = "none";
          current-system = "x86_64-linux";
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
      # Cat's projector
      Lagurus = let
        host-type = "kiosk";
        display-type = "wayland";
        host-options = "";
        current-system = "x86_64-linux";
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          host-type = "kiosk";
          display-type = "wayland";
          current-system = "x86_64-linux";
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
      # Jess desktop
      Cichlid = let
        host-type = "desktop";
        display-type = "wayland";
        host-options = "printers";
        current-system = "x86_64-linux";
      in lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          secrets = "/etc/nixos/secrets";
          host-type = "desktop";
          display-type = "wayland";
          host-options = "printers";
          current-system = "x86_64-linux";
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
    Cichlid = let
        host-type = "desktop";
        display-type = "wayland";
        host-options = "printers installer";
        current-system = "x86_64-linux";
      in nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs outputs;
        secrets = "/etc/nixos/secrets";
        host-type = "desktop";
        display-type = "wayland";
        host-options = "printers installer";
        current-system = "x86_64-linux";
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
    # Available through `home-manager --flake .#your-username@your-hostname`
    # or `nh home switch -c kent@mobile` if nh is available
    homeConfigurations = {
      "kent@mobile" = let
        system-details = {
          host-type = "android";
          display-type = "x11";
          host-options = "";
          current-system = "aarch64-linux";
        };
      in lib.homeManagerConfiguration {
        modules = [
          ./home/kent
          ./home/kent/mobile
          nixvim.homeManagerModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          host-type = system-details.host-type;
          display-type = system-details.display-type;
          host-options = system-details.host-options;
          current-system = system-details.current-system;
        };
      };
    };
  };
}
