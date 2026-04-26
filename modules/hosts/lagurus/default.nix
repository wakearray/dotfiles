{ domain, ... }:
let
  devices = import ../../devices.nix;
  serverIP = devices.delaware.ip;
in
{
  # modules/hosts/lagurus
  config = {
    servers = {
      authelia = {
        enable = true;
        sopsFile = ./authelia.yaml;
      };
      nginx = {
        enable = true;
        domain = domain;
        ariaNg = {
          enable = true;
          localIP = serverIP;
        };
        audiobookshelf = {
          enable = true;
          localIP = serverIP;
        };
        authelia = {
          enable = true;
        };
        endurain = {
          enable = true;
          localIP = serverIP;
        };
        forgejo = {
          enable = true;
          localIP = serverIP;
        };
        paperless = {
          enable = true;
          localIP = serverIP;
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
