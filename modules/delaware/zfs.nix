{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  # Enable ZFS boot functionality.
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "ae67779a";
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  # Enable ZFS pool (native).
  boot.zfs.extraPools = [ "sambazfs" ];

  environment.systemPackages = with pkgs; [
    # Needed for doing things with ZFS
    zfs
  ];
}
