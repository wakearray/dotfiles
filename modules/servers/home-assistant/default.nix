{ lib, config, ... }:
let
  cfg = config.servers.home-assistant;
in
{
  # WIP
  options.servers.home-assistant = with lib; {
    enable = mkEnableOption "An opinionated Home-Assistant config.";
  };

  config = lib.mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = true;
    };
  };
}
