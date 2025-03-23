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
        qemu.ovmf.enable = true;
        allowedBridges = [ "br0" ];
      };
    };

    environment.systemPackages = with pkgs; [
      # For virt-install
      virt-manager

      # For lsusb
      usbutils
    ];

    networking = {
#      defaultGateway = "192.168.0.1";
      bridges = {
        br0 = {
          interfaces = [ "enp1s0f0" ];
        };
      };
#      interfaces = {
#        br0 = {
#          useDHCP = false;
#          adresses.ipv4 = {
#            address = "192.168.0.90";
#            prefixLength = 24;
#          };
#        };
#      };
    };
  };
}
