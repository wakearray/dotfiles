{ lib, config, pkg, ... }:
{
  options.servers.home-assistant = with lib; {
    enable = mkEnableOption "";
  };

  config = {
    services.home-assistant = {
      enable = true;
      settings = {
        homeassistant.enabled = config.services.home-assistant.enable;
        permit_join = true;
        serial = {
          port = "/dev/ttyACM1";
        };
      };
    };
  };
}
