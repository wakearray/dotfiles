{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = config.services.home-assistant.enable;
      permit_join = true;
    };
  };

  environment.systemPackages = [

  ];
}
