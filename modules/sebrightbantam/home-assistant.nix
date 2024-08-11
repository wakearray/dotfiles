{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  environment.systemPackages = with pkgs; [
    python312Packages.isal
    python312Packages.aiohttp-isal
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      # "esphome"
      # "met"
      # "radio_browser"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      isal = {};
    };
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];
}
