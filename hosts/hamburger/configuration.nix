{ ... }:

{
  imports =
  [
    ./hardware-configuration.nix
    ./disko-config.nix
    ../../modules
    ../../modules/hosts/hamburger
    ../../users/kent
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable networking.
  networking = {
    networkmanager.enable = true;
    hostName = "Hamburger"; # Define your hostname
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
