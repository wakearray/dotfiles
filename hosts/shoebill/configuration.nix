{ modulesPath, ... }:
{
  imports =
  [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    ../../modules
    # ../../modules/gui/themes/catppuccin.nix
    ../../modules/hosts/shoebill
    ../../users/jess
    ../../users/kent
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
    hostName = "Shoebill";
    firewall.enable = true;
  };

  # zsh completion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  hardware = {
    bluetooth.enable = true;
    # Enable keyboard firmware control
    keyboard.qmk.enable = true;
  };

  system.stateVersion = "24.11";
}
