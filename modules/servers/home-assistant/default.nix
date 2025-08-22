{ lib, config, pkgs, ... }:
let
  home-assistant = config.servers.home-assistant;
in
{
  # /modules/servers/home-assistant/

  #imports = [
  #  ./script-install.nix
  #];

  options.servers.home-assistant = with lib; {
    enable = mkEnableOption "Enable a libvirtd installation of Home Assistant.";

    bridge = {
      name = mkOption {
        type = types.str;
        default = "br0";
        description = "Name of the bridge you want to use for the home-assistant virtual machine.";
      };
      interface = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The name of the interface you want assigned to the bridge. Use `ip a` to see available interfaces, if only one on the network has an IP address, use that one. Name may look something like `enp1s0f0`";
      };
    };
  };

  config = lib.mkIf home-assistant.enable {
    warnings = (
      lib.optionals (home-assistant.bridge.interface == null) "Interface cannot be null. Set this to the physical interface you want the home-assistant virtual machine to use. Use `ip a` to see a list of interfaces on your machine."
    );

    virtualisation = {
      libvirtd = {
        enable = true;
        # Used for UEFI boot of Home Assistant OS guest image
        qemu.ovmf.enable = true;
        allowedBridges = (lib.splitString " " home-assistant.bridge.name);
      };
    };

    environment.systemPackages = with pkgs; [
      # For virt-install
      virt-manager

      # For lsusb
      usbutils
    ];

    networking = {
      useDHCP = false;
      bridges = {
        "${home-assistant.bridge.name}" = {
          interfaces = (lib.splitString " " home-assistant.bridge.interface);
        };
      };
      interfaces = {
        "${home-assistant.bridge.name}" = {
          useDHCP = true;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
