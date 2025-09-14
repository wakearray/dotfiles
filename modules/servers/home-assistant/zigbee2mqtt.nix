{ config, lib, ... }:
let
  cfg = config.servers.b;
in
{
  options.servers.home-assistant.zigbee2mqtt = with lib; {
    enable = mkEnableOption "WIP: Enable an opinionated zigbee2mqtt config.";
  };

  config = lib.mkIf cfg.enable {
    services.zigbee2mqtt = {
      enable = true;
    };
  };
}
