{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  # Enable if MQTT server needs to be accessed on the local or remote network
  # Currently I only plan to use it on localhost
  # networking.firewall.allowedTCPPorts = [ 1883 ];

  environment.systemPackages = [

  ];
}
