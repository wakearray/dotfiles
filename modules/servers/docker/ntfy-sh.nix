{ lib, config, ... }:
let
  cfg = config.servers.docker.ntfy-sh;
in
{
  options.servers.docker.ntfy-sh = with lib; {
    enable = mkEnableOption "Enable an opinionated ntfy-sh config.";

    domain = mkOption {
      type = types.str;
      default = "ntfy.example.com";
      description = "The domain you want ntfy-sh hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 2586;
      description = "The local port you want ntfy-sh hosted at.";
    };

    cacheDirectory = mkOption {
      type = types.str;
      default = "/var/cache/ntfy";
      description = "String of path to where you want the cache to be located.";
    };

    configDirectory = mkOption {
      type = types.str;
      default = "/etc/ntfy";
      description = "String of path to where you want the server.yaml to be located.";
    };

    logLevel = mkOption {
      type = types.enum [ "trace" "debug" "info" "warn" "error" ];
      default = "info";
      description = "Defines the default log level, can be one of trace, debug, info, warn or error.";
    };

    visitorRequestLimitExemptHosts = mkOption {
      type = types.str;
      default = "70.109.49.31";
      description = "A comma separated list of hostnames and IP addresses that you do not want request limits to be applied to.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The location of the file containing all the needed secrets.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.ntfy = {
      image = "binwiederhier/ntfy:latest";
      autoStart = true;
      cmd = [
        "serve"
      ];
      environmentFiles = [
        config.sops.templates."ntfyEnvironmentFile.env".path
      ];
      volumes = [
        "${cfg.cacheDirectory}:/var/cache/ntfy"
        "${cfg.configDirectory}:/etc/ntfy"
      ];
      ports = [
        "127.0.0.1:${toString cfg.localPort}:80"
        #"25:25"
      ];
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.localPort}";
            proxyWebsockets = true;
          };
        };
        extraConfig = ''
          proxy_set_header Host ${cfg.domain};
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

          proxy_connect_timeout 3m;
          proxy_send_timeout 3m;
          proxy_read_timeout 3m;

          client_max_body_size 0; # Stream request body to backend
        '';
      };
    };

    # sops secrets
    sops.secrets = let
      opts = {
        sopsFile = cfg.sopsFile;
        #mode = "0400";
        #owner = cfg.user;
        #group = cfg.group;
      };
    in {
      #ntfy-web-push-public-key = opts;
      #ntfy-web-push-private-key = opts;
      #ntfy-auth-users = opts;
      #ntfy-auth-access = opts;
      #smtp-sender-from = opts;
      #smtp-server-listen = opts;
      #smtp-server-domain = opts;
      #smtp-server-addr-prefix = opts;
      #smtp-sender-addr = opts;
      #smtp-sender-user = opts;
      #smtp-sender-pass = opts;
    };

    sops.templates."ntfyEnvironmentFile.env" = {
        #NTFY_AUTH_USERS='${config.sops.placeholder.ntfy-auth-users}'
        #NTFY_AUTH_ACCESS='${config.sops.placeholder.ntfy-auth-access}'
        #NTFY_SMTP_SENDER_FROM="${config.sops.placeholder.smtp-sender-from}"
        #NTFY_SMTP_SERVER_LISTEN=:25
        #NTFY_SMTP_SERVER_DOMAIN="${config.sops.placeholder.smtp-server-domain}"
        #NTFY_SMTP_SERVER_ADDR_PREFIX="${config.sops.placeholder.smtp-server-addr-prefix}"
        #NTFY_SMTP_SENDER_ADDR="${config.sops.placeholder.smtp-sender-addr}"
        #NTFY_SMTP_SENDER_USER="${config.sops.placeholder.smtp-sender-user}"
        #NTFY_SMTP_SENDER_PASS="${config.sops.placeholder.smtp-sender-pass}"
      content  = ''
        NTFY_BASE_URL=https://${cfg.domain}
        NTFY_CACHE_FILE=${toString cfg.cacheDirectory}/cache.db
        NTFY_AUTH_FILE=${toString cfg.cacheDirectory}/auth.db
        NTFY_AUTH_DEFAULT_ACCESS=deny-all
        NTFY_BEHIND_PROXY=true
        NTFY_ATTACHMENT_CACHE_DIR=${toString cfg.cacheDirectory}/attachments
        NTFY_ENABLE_LOGIN=true
        NTFY_REQUIRE_LOGIN=true
        NTFY_ENABLE_SIGNUP=false
        NTFY_ENABLE_RESERVATIONS=true

        NTFY_VISITOR_REQUEST_LIMIT_EXEMPT_HOSTS=${cfg.visitorRequestLimitExemptHosts}
        NTFY_LOG_LEVEL=${cfg.logLevel}

        TZ=${config.time.timeZone}
      '';
    };
  };
}
