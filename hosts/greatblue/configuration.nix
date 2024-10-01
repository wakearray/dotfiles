{ ... }:
let
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
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Enable binfmt emulation of aarch64-linux.
    # Supports building for phone architectures.
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "GreatBlue";
    firewall.enable = true;
  };

  # Enable keyboard access
  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
  };

  system.stateVersion = "23.11";
}
