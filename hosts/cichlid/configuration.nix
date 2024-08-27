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
    ../../modules/gui/catppuccin.nix
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
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "Cichlid";
    firewall.enable = true;
  };
  
  # zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];
  
  hardware = {
    bluetooth.enable = true;
    # Enable keyboard firmware control
    keyboard.qmk.enable = true;
  };

  system.stateVersion = "24.05";
}
