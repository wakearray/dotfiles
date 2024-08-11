{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment.systemPackages = [

  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ <other ports> 8123 ];
}
