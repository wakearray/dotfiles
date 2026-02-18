{ lib, config, ... }:
let
  cfg = config.servers.z2m;
in
{
  options.servers.z2m = with lib; {
    enable = mkEnableOption "Enable an opinionated Zigbee2MQTT config.";
  };

  services.zigbee2mqtt = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      homeassistant = config.services.home-assistant.enable;
      permit_join = true;
    };
  };
}
