{ lib, config, ... }:
let
  forgejo = config.servers.forgejo;
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

    mail = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the email notification function.";
      };

      smtpAddr = mkOption {
        type = types.str;
        default = "mail.${forgejo.domain}";
        description = "The address of the SMTP server you intend to use. Be default it's set to add `.mail` to the front of your selected domain name.";
      };

      from = mkOption {
        type = types.str;
        default = "noreply@${forgejo.domain}";
        description = "The address of the account you want emails to be sent from.";
      };

      name = mkOption {
        type = types.str;
        default = "noreply";
        description = "The name of the account you want emails to be sent from.";
      };
    };

    actions = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the email notification function.";
      };

      defaultActionsUrl = mkOption {
        type = types.enum [ "github" ];
      };
    };
  };

  config = lib.mkIf forgejo.enable {
    # Forgejo
    services.forgejo = {
      enable = true;
      database.type = "postgres";
      # Enable support for Git Large File Storage
      lfs.enable = true;
      secrets = {
        mailer = {
          PASSWD = "/run/secrets/mail-server-noreply";
        };
      };
      settings = {
        server = {
          DOMAIN = "git.${forgejo.domain}";
          # You need to specify this to remove the port from URLs in the web UI.
          ROOT_URL = "https://${forgejo.domain}/";
          PROTOCOL = "https";
          HTTP_PORT = forgejo.localPort;
        };
        # You can temporarily allow registration to create an admin user.
        service.DISABLE_REGISTRATION = forgejo.disableRegistration;
        # Add support for actions, based on act: https://github.com/nektos/act
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
        # Sending emails is completely optional
        # You can send a test email from the web UI at:
        # Profile Picture > Site Administration > Configuration >  Mailer Configuration
         mailer = {
           ENABLED = forgejo.enable;
           SMTP_ADDR = forgejo.mail.smtpAddr;
           FROM = "noreply@${forgejo.domain}";
           USER = "noreply@${forgejo.domain}";
         };
      };
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "git.${forgejo.domain}" = {
        enableACME = true;
        forceSSL = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
        locations = {
          "/" = {
            proxyPass = "http://localhost:${builtins.toString forgejo.localPort}";
          };
        };
      };
    };
  };
}
