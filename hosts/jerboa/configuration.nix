{ ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hosts/jerboa
    ../../users/kent
    ../../users/entertainment
  ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "Jerboa"; # TV computer
    networkmanager.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = "entertainment";
      };
      defaultSession = "dwm";
    };
    windowManager.dwm.enable = true;
  };

  system.stateVersion = "23.11";
}
