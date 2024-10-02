{ pkgs, ... }:
{
  # Enable ZFS boot functionality.
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      forceImportRoot = false;
      # Enable ZFS pool (native).
      extraPools = [ "sambazfs" ];
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
