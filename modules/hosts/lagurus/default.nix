{ domain, ... }:
let
  devices = import ../../devices.nix;
  serverIP = devices.delaware.ip;
in
{
  # modules/hosts/lagurus
  config = {
    servers = {
      nginx = {
        enable = true;
        domain = domain;
        audiobookshelf = {
          enable = false;
          localIP = serverIP;
        };
        endurain = {
          enable = true;
          localIP = serverIP;
          localPort = 8060;
        };
        forgejo = {
          enable = false;
          localIP = serverIP;
        };
        homeassistant = {
          enable = true;
          localIP = "192.168.0.138";
        };
      };
      kanidm = {
        enable = true;
        domain = domain;
      };

      encryption.luks.remoteUnlock = {
        enable = true;
        availableKernelModules = [
          # USB bus
          "xhci_pci"

          # Kernal modules needed for ethernet use
          "r8153_ecm"
          "cdc_ether"
          "usbnet"
          "r8152"
          "mii"
          "libphy"
          "led_class"
          "mdio_bus"
        ];
      };
    };
    services = {
      # Smartd doesn't work on Lagurus
      smartd.enable = false;
      # Don't auto mount USB drives on the LDAP/IdP server
      gvfs.enable = false;
      # Userborn appears to cause rebuilding to stall
      userborn.enable = false;
    };

    systemd = {
      network.networks."10-usb-ethernet" = {
        matchConfig.Name = "enp0s21f0u6";
        networkConfig.DHCP = "yes";
        # Helps if the USB bus is slow to handshake
        linkConfig.RequiredForOnline = "yes";
      };
      services.sshd = {
        after = [ "network-online.target" ];
        before = [ "network-online.target" ];
      };
    };
  };
}
