{ lib, config, ... }:
let
  cfg = config.servers.encryption.luks.remoteUnlock;
in
{
  options.servers.encryption.luks.remoteUnlock = with lib; {
    enable = mkEnableOption "Enable remote unlock of LUKS full disk encryption.";

    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = config.users.users.kent.openssh.authorizedKeys.keys;
      description = "The public keys of the clients you want to connect to the host.";
    };

    availableKernelModules = mkOption {
      type = types.listOf types.str;
      default = [ "r8169" ];
      description = "A list of kernel modules needed to bring the NIC online. Use `lspci -v | grep -iA8 'network\|ethernet'` to find out what kernel module is needed for your pci NIC. If using a usb NIC, use `lsusb -vt | grep -iB1 \"network\|ethernet\"` to find the needed driver. Don't forget to look at `lsusb -vt` to find the bus the NIC is plugged into and add that kernel module as well. Use `lsmod` to see the the currently loaded kernel modules.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      #kernelParams = [ "ip=::::${config.networking.hostName}::dhcp:::" ];
      initrd = {
        availableKernelModules = cfg.availableKernelModules;
        systemd = {
          enable = true;
          network.enable = true;
        };
        network = {
          enable = true;
          flushBeforeStage2 = true;
          ssh = {
            enable = true;
            port = 22;
            authorizedKeys = cfg.authorizedKeys;
            hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
          };
        };
      };
    };
  };
}
