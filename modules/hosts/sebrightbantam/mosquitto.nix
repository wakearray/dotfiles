{ ... }:
{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  # Enable if MQTT server needs to be accessed on the local or remote network
  # networking.firewall.allowedTCPPorts = [ 1883 ];
}
