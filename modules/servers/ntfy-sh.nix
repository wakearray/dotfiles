{ lib, config, ... }:
let
  cfg = config.servers.ntfy;
in
{
  # WIP
  options.servers.ntfy = with lib; {
    enable = mkEnableOption "Enable an opinionated ntfy-sh server.";

    domain = mkOption {
      type = types.str;
      default = "ntfy.example.com";
      description = "Public facing base URL of the service

This setting is required for any of the following features:

- attachments (to return a download URL)
- e-mail sending (for the topic URL in the email footer)
- iOS push notifications for self-hosted servers (to calculate the Firebase poll_request topic)
- Matrix Push Gateway (to validate that the pushkey is correct)
";
    };

    localPort = mkOption {
      type = types.port;
      default = 2586;
      description = "Port of the webserver on the local machine.";
    };

    cacheRootDirectory = mkOption {
      type = types.str;
      default = "/var/lib/ntfy-sh";
      description = "Root directory of the cache files.";
    };

    authFile = mkOption {
      type = types.str;
      default = "/var/lib/ntfy-sh/user.db";
      description = "Where to store the SQLite db file the contains the users and password hashes.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be formatted as a single variable named `ntfyEnvironmentVars` representing the entire ntfy environment variables file.";
    };

  };

  config = lib.mkIf cfg.enable {
    services = {
      ntfy-sh = {
        enable = true;
        settings = {
          base-url = "https://${cfg.domain}";
          listen-http = "127.0.0.1:${toString cfg.localPort}";
          # firebase-key-file = "/etc/ntfy/firebase.json";
          cache-file = "${cfg.cacheRootDirectory}/cache.db";
          auth-file = "${cfg.authFile}";
          behind-proxy = true;
          attachment-cache-dir = "${cfg.cacheRootDirectory}/attachments";
          keepalive-interval = "45s";
        };
        environmentFile = config.sops.templates."ntfyEnvironmentFile".path;
      };

      # Nginx reverse proxy
      nginx.virtualHosts."${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.localPort}";
          proxyWebsockets = true;
        };
      };
    };

    sops.secrets = let
      opts = {
        sopsFile = cfg.sopsFile;
        mode = "0400";
        owner = "ntfy-sh";
        group = "ntfy-sh";
      };
    in {
      smtp-sender-from = opts;
      smtp-server-listen = opts;
      smtp-server-domain = opts;
      smtp-server-addr-prefix = opts;
      smtp-sender-addr = opts;
      smtp-sender-user = opts;
      smtp-sender-pass = opts;
      ntfyEnvironmentVars = opts;
    };

    sops.templates."ntfyEnvironmentFile" = {
      content = ''
        NTFY_SMTP_SENDER_FROM="${config.sops.placeholder.smtp-sender-from}"
        NTFY_SMTP_SERVER_LISTEN="${config.sops.placeholder.smtp-server-listen}"
        NTFY_SMTP_SERVER_DOMAIN="${config.sops.placeholder.smtp-server-domain}"
        NTFY_SMTP_SERVER_ADDR_PREFIX="${config.sops.placeholder.smtp-server-addr-prefix}"
        NTFY_SMTP_SENDER_ADDR="${config.sops.placeholder.smtp-sender-addr}"
        NTFY_SMTP_SENDER_USER="${config.sops.placeholder.smtp-sender-user}"
        NTFY_SMTP_SENDER_PASS="${config.sops.placeholder.smtp-sender-pass}"
        ${config.sops.placeholder.ntfyEnvironmentVars}
      '';
      mode = "0400";
      owner = "ntfy-sh";
      group = "ntfy-sh";
    };
  };
}
