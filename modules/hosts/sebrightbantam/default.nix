{ ... }:
{
  ## These are the defaults I want on SebrightBantam only:
  imports = [
    ./home-assistant.nix
    #./zigbee2mqtt.nix
    #./mosquitto.nix

    #./forgejo.nix
  ];

  host-options = {
    display-system = "none";
    host-type = "server";
  };
}