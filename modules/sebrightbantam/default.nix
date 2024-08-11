{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  ## These are the defaults I want on SebrightBantam only:
  imports = [
    ./home-assistant.nix
    #./zigbee2mqtt.nix
    #./mosquitto.nix

    #./forgejo.nix
  ];

  environment.systemPackages = [

  ];
}
