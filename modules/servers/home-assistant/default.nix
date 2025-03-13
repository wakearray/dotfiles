{ lib, config, pkgs, ... }:
let
  home-assistant = config.servers.home-assistant;
in
{
  options.servers.home-assistant = with lib; {
    enable = mkEnableOption "Enable a libvirtd installation of Home Assistant.";
  };

  config = lib.mkIf home-assistant.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        # Used for UEFI boot of Home Assistant OS guest image
        qemu.ovmf = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # For virt-install
      virt-manager

      # For lsusb
      usbutils
    ];
  };
}
