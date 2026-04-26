{ config, lib, ... }:
let
  cfg = config.servers.miniflux;
in
{
  options.servers.miniflux = with lib; {
    enable = mkEnableOption "Enable an opinionated Miniflux config.";

    localPort = mkOption {
      type = types.port;
      default = 8080;
      description = "The port you want to use when locally accessing the server on the same network.";
    };

    sameServerHost = mkEnableOption "If false, localPort will be exposed, if true it won't be." // { default = true;};

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be formatted as a single variable named `minifluxCredentialsEnvironmentVars` representing the entire miniflux environment variables file.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = !(isNull cfg.sopsFile);
      message = "Please define a sops file with admin credentials.";
    }];

    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.sops.templates."minifluxCredentialsEnvironmentFile".path;
      config = {
        LISTEN_ADDR = "127.0.0.1:${toString cfg.localPort}";
      };
    };

    networking.firewall.allowedTCPPorts = [] ++ lib.optionals (!cfg.sameServerHost) [ cfg.localPort ];

    sops.secrets.minifluxCredentialsEnvironmentVars = {
      sopsFile = cfg.sopsFile;
    };

    sops.templates."minifluxCredentialsEnvironmentFile" = {
      content = ''
        ${config.sops.placeholder.minifluxCredentialsEnvironmentVars}
      '';
    };
  };
}
