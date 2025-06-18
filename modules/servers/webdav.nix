{ lib, config, ... }:
let
  webdav = config.servers.webdav;
in
{
  ## WIP: Setup for Delaware with SOPS support and correct user directories
  options.servers.webdav = with lib; {
    enable = mkEnableOption "Enable an opinionated webdav install.";

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "The IPv4 address you want to listen to requests from.";
    };

    port = mkOption {
      type = types.port;
      default = 8050;
      description = "Which port you'd like to access this webdav server at.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be formatted as a single variable named `webdavEnvironmentVars`";
    };
  };

  config = lib.mkIf webdav.enable {
    services.webdav = {
      enable = true;
      settings = {
        address = webdav.address;
        port = webdav.port;
        directory = "/data/userdata/public";
        permissions = "R";
        users = [
          {
            username = "{env}USER1_USERNAME";
            password = "{env}USER1_PASSWORD";
            directory = "/data/userdata/Kent";
          }
          {
            username = "{env}USER2_USERNAME";
            password = "{env}USER2_PASSWORD";
            directory = "/data/userdata/Jess";
          }
          {
            username = "{env}USER3_USERNAME";
            password = "{env}USER3_PASSWORD";
            directory = "/data/userdata/Entertainment";
          }
          {
            username = "{env}USER4_USERNAME";
            password = "{env}USER4_PASSWORD";
          }
        ];
      };
      # Use an environment file to allow passwords to be encrypted with SOPS
      environmentFile = config.sops.templates."webdavEnvironmentFile".path;
    };

    sops.secrets.webdavEnvironmentVars = {
      sopsFile = webdav.sopsFile;
      mode = "0400";
      owner = "webdav";
      group = "webdav";
    };

    sops.templates."webdavEnvironmentFile" = {
      content = ''
        ${config.sops.placeholder.webdavEnvironmentVars}
      '';
      mode = "0400";
      owner = "webdav";
      group = "webdav";
    };
    networking.firewall = {
      allowedUDPPorts = [ webdav.port ];
      allowedTCPPorts = [ webdav.port ];
    };
  };
}
