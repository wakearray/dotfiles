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
      # url = "github:nix-community/hom-manager/release-24.05";
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
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

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, nur, lix-module, home-manager, nixgl, nixvim, sops-nix, simple-nixos-mailserver, nixos-generators, catppuccin, ... }@inputs:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    pkgsFor = system: import nixpkgs {
      inherit system;
      overlays = [ nixgl.overlay ];
    };
  in
  {
    inherit lib;
    #nixosModules = import ./modules/nixos;
    #homeManagerModules = import ./modules/home-manager;
    #templates = import ./templates;
    overlays = import ./overlays {inherit inputs outputs;};
    #hydraJobs = import ./hydra.nix {inherit inputs outputs;};

    #packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs;});
    #devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    #formatter = forEachSystem (pkgs: pkgs.alejandra);

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
        ];
      };
      Lagurus = lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
            secrets = "/etc/nixos/secrets";
        };
        modules = [
          ./hosts/lagurus/configuration.nix
          nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
          lix-module.nixosModules.default
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

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "kent@mobile" = lib.homeManagerConfiguration {
        modules = [
          ./home/kent
          ./home/kent/mobile
          nixvim.homeManagerModules.nixvim
          sops-nix.homeManagerModules.sops
        ];
        pkgs = pkgsFor "aarch64-linux";
        # pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };
  };
}
