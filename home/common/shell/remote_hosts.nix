{ config, lib, ... }:
let
  devices = import ../../../modules/devices.nix;

  # Function to list available hosts
  listHostAliasesForUser = user:
  let
    isUserInDevice = device: lib.elem user device.value.users;
    devicesForUser = lib.filter isUserInDevice (lib.attrsToList devices);
    devicesAvailable = map (device: {
      name = device.name;
      value = "${device.value.prettyName} ${device.value.ip}";
    }) devicesForUser;
  in
  toString devicesAvailable;

  # Get current user
  currentUser = config.home.username;

  # Generate aliases for the current user
  availableHosts = listHostAliasesForUser currentUser;
in
{
  # WIP
  # WIP This script should show which hosts are online, and provide a menu to connect to them as well as send a magic packet to wake them up.
  # WIP

  config = {
    home = {
      file.".local/bin/hosts" = {
        enable = true;
        force = true;
        executable = true;
        text = /*bash*/ ''
          #!/usr/bin/env bash
        '';
      };
    };
  };
}
