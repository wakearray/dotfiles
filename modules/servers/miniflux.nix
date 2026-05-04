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

    #sameServerHost = mkEnableOption "If false, localPort will be exposed, if true it won't be." // { default = true;};

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
        OAUTH2_CLIENT_ID = "miniflux";
        OAUTH2_CLIENT_SECRET_FILE = "/run/credentials/miniflux.service/oauth_secret";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://idm.voicelesscrimson.com/oauth2/openid/miniflux";
        OAUTH2_OIDC_PROVIDER_NAME = "Kanidm";
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_REDIRECT_URL = "https://rss.voicelesscrimson.com/oauth2/oidc/callback";
        OAUTH2_USER_CREATION = "1";
      };
    };

    # networking.firewall.allowedTCPPorts = [] ++ lib.optionals (!cfg.sameServerHost) [ cfg.localPort ];

    sops.secrets = let opts = { sopsFile = cfg.sopsFile; };
    in {
      minifluxCredentialsEnvironmentVars = opts;
      oauth2_client_secret = opts;
    };

    sops.templates."minifluxCredentialsEnvironmentFile".content = ''
      ${config.sops.placeholder.minifluxCredentialsEnvironmentVars}
    '';

    systemd.services.miniflux.serviceConfig = {
      # This maps the root-owned secret to a file named 'oauth_secret'
      # inside the service's private credentials folder.
      LoadCredential = [
        "oauth_secret:/run/secrets/oauth2_client_secret"
      ];
    };
  };
}
