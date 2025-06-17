{ lib, config, ... }:
let
  webdav = config.servers.webdav;
in
{
  ## WIP: Setup for Delaware with SOPS support and correct user directories
  options.servers.webdav = with lib; {
    enable = mkEnableOption "Enable an opinionated webdav install.";
  };

  config = lib.mkIf webdav.enable {
    services.webdav = {
      enable = true;
      settings = {
        address = "0.0.0.0";
        port = 8050;
        scope = "/srv/public";
        modify = true;
        auth = true;
        users = [
          {
            username = "{env}KENT_USERNAME";
            password = "{env}KENT_PASSWORD";
          }
          {
            username = "{env}JESS_USERNAME";
            password = "{env}JESS_PASSWORD";
          }
          {
            username = "{env}ENTERTAINMENT_USERNAME";
            password = "{env}ENTERTAINMENT_PASSWORD";
          }
          {
            username = "{env}KENT_USERNAME";
            password = "{env}KENT_PASSWORD";
          }
        ];
      };
      # Use an environment file to allow passwords to be encrypted with SOPS
      environmentFile = "";
    };
  };
}
