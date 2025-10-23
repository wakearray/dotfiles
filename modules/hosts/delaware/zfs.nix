{ pkgs, config, ... }:
let
  devices = import ../../modules/devices.nix;

  # Function to extract keys for a specific user
  getKeysForUser = user:
    let
      isUserInDevice = device: lib.elem user device.users;
    in
      map (device: device.key) (lib.filter isUserInDevice (lib.attrValues devices));

  userKeys = getKeysForUser "kent";
in

{
  # Enable ZFS boot functionality.
  boot = {
    supportedFilesystems = [ "zfs" ];

    zfs = {
      forceImportRoot = false;
      # Enable ZFS pool (native).
      extraPools = [ "seagate8tb" ];
    };

    # Enable SSH during boot so that the encryption pass can be entered over SSH
    initrd.network = {
      enable = true;
      ssh = {
        enable = true;
        authorizedKeyFiles = config.users.users."kent".openssh.authorizedKeys.keyFiles;
        hostKeys = [ /etc/ssh/ssh_host_ed25519_key ];
      };
    };
  };

  networking.hostId = "ae67779a";

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Needed for doing things with ZFS
    zfs
  ];
}
