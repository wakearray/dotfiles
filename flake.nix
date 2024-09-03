{
  description = "WakeNet Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        #darwin.follows = ""; # This currently does nothing on ragenix
      };
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

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, lix-module, home-manager, nixvim, agenix, simple-nixos-mailserver, nixos-generators, catppuccin, ... }@inputs:
  let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib; # // nixpkgs-unstable.lib;
    systems = [ "aarch64-linux" "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
#     forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
#     pkgsFor = lib.genAttrs systems (
#       system:
#         import nixpkgs {
#           inherit system;
#           config.allowUnfree = true;
#         }
#     );
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
          agenix.nixosModules.default
	  {environment.systemPackages = [ agenix.packages.x86_64-linux.default ];}
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.kent = { 
	        imports = [
	          ./home/kent
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
          agenix.nixosModules.default
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
          agenix.nixosModules.default
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
          agenix.nixosModules.default
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
          agenix.nixosModules.default
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
        agenix.nixosModules.default
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
	  ./home/kent/mobile.nix 
	];
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "kent@greatblue" = lib.homeManagerConfiguration {
        modules = [
	  ./home/kent
	  ./home/kent/greatblue.nix 
	];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "kent@delaware" = lib.homeManagerConfiguration {
        modules = [
	  ./home/kent
	  ./home/kent/delaware.nix 
        ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };
  };
}
