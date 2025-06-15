{ ... }:
{
  imports =
  [
    ../../modules
    ../../users/kent
    ../../users/jess
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable networking.
  networking = {
    networkmanager.enable = true;
    hostName = "CustomInstaller"; # Define your hostname
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  system.stateVersion = "24.11";
}
