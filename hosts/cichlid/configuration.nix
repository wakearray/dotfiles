{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let
in
{
  imports =
  [
    #./hardware-configuration.nix
    ../../modules
    ../../modules/gui
    ../../modules/cichlid
    ../../users/jess

    ../../modules/installer.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth = { 
      enable = true;
      catppuccin = { 
        enable = true; 
	flavor = "macchiato";
      };
    };
  };

  services.displayManager.sddm.catppuccin = { 
    enable = true;
    flavor = "macchiato";
  };

  catppuccin = { 
    enable = true;
    accent = "mauve";
    flavor = "macchiato";
  };

  console.catppuccin = { 
    enable = true;
    flavor = "macchiato";
  };
  
  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "Cichlid";
    firewall.enable = true;
  };
  
  hardware = {
    bluetooth.enable = true;
    # Enable keyboard firmware control
    keyboard.qmk.enable = true;
  };

  system.stateVersion = "24.05";
}
