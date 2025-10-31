{ lib, config, ... }:
let
  cfg = config.servers.forgejo;
in
{
  options.servers.forgejo = with lib; {
    enable = mkEnableOption "Enable an opinionated forgejo configuration.";

    domain = mkOption {
      type = types.str;
      default = "example.com";
      description = "The domain you want to access the server from. If you want to access at https://git.example.com, then make this option `example.com`";
    };

    localPort = mkOption {
      type = types.port;
      default = 8065;
      description = "The port you want to use when locally accessing the server on the same network.";
    };

    disableRegistration = mkOption {
      type = types.bool;
      default = true;
      description = "When `disableRegistration` = true, no accounts will be allowed to be registered.";
    };

    actions = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Forgejo Actions. Remember Forgejo Actions relies on Forgejo Runner which must be installed seperately.";
      };

      defaultActionsUrl = mkOption {
        type = types.str;
        default = "https://data.forgejo.org";
        description = "In a workflow, when used: does not specify an absolute URL, the value of DEFAULT_ACTIONS_URL is prepended to it.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Forgejo
    services.forgejo = {
      enable = true;
      database.type = "postgres";
      # Enable support for Git Large File Storage
      lfs.enable = true;
      #secrets = {
      #  mailer = {
      #    PASSWD = "/run/secrets/mail-server-noreply";
      #  };
      #};
      settings = {
        server = {
          DOMAIN = "localhost";
          ROOT_URL = "https://git.${cfg.domain}/";
          PROTOCOL = "http";
          HTTP_PORT = cfg.localPort;
        };
        # You can temporarily allow registration to create an admin user.
        service.DISABLE_REGISTRATION = cfg.disableRegistration;
        # Add support for actions, based on act: https://github.com/nektos/act
        actions = {
          ENABLED = cfg.actions.enable;
          DEFAULT_ACTIONS_URL = cfg.actions.defaultActionsUrl;
        };
        # Sending emails is completely optional
        # You can send a test email from the web UI at:
        # Profile Picture > Site Administration > Configuration >  Mailer Configuration
        mailer = {
          ENABLED = true;
          PROTOCOL = "smtp+starttls";
          SMTP_ADDR = "mail.smtp2go.com";
          SMTP_PORT = 8025;
          FROM = "forgejo@${cfg.domain}";
          ENVELOPE_FROM = "forgejo@${cfg.domain}";
          USER = "forgejo@${cfg.domain}";
          PASSWD_URI = "file:/run/secrets/forgejo_mailer_password";
        };
      };
    };

    sops.secrets = let
      opts = {
        sopsFile = ./secrets.yaml;
        mode     = "0400";
        owner    = "forgejo";
        group    = "forgejo";
      };
    in
    {
      forgejo_mailer_password = opts;
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "git.${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations = {
          "/" = {
            proxyPass = "http://localhost:${builtins.toString cfg.localPort}";
          };
        };
      };
    };
  };
}

