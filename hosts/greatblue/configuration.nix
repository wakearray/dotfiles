{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let
  secrets = "/etc/nixos/secrets";
in
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/greatblue
    ../../users/kent
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "GreatBlue";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable keyboard access
  hardware.keyboard.qmk.enable = true;

  # Enale direnv
  programs.direnv.enable = true;

  # Services
  services.flatpak.enable = true;

  systemd.user.services.kent-autostart = {
    description = "Deletes old derivations";
    serviceConfig.PassEnvironment = "DISPLAY";
    script = ''
      #!/bin/sh
      nix-collect-garbage --delete-older-than 7d
    '';
    wantedBy = [ "multi-user.target" ]; # starts after login
  };

  # Firewall.
  networking.firewall.enable = true;

  # Hardware.
  hardware.bluetooth.enable = true;

  # Enable binfmt emulation of aarch64-linux.
  # Supports building for phone architectures.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "23.11";
}
