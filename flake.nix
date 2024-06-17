{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

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

    inputs.simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager, agenix, simple-nixos-mailserver, ... }@inputs:
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
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/greatblue/configuration.nix
          nixos-hardware.nixosModules.gpd-win-max-2-2023
          agenix.nixosModules.default
        ];
      };
      Delaware = lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/delaware/configuration.nix
          agenix.nixosModules.default
          simple-nixos-mailserver.nixosModule
        ];
      };
      Lagurus = lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/lagurus/configuration.nix
          agenix.nixosModules.default
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "kent@greatblue" = lib.homeManagerConfiguration {
        modules = [ ./home/kent/greatblue.nix ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
      "kent@delaware" = lib.homeManagerConfiguration {
        modules = [ ./home/kent/delaware.nix ];
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
      };
    };
  };
}
