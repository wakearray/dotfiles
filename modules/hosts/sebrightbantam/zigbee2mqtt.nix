{ config, ... }:
{
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = config.services.home-assistant.enable;
      permit_join = true;
    };
  };
}
