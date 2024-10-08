{ domain, ... }:
{
    # Forgejo
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git.${domain}";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${domain}/";
        PROTOCOL = "https";
        HTTP_PORT = 8065;
      };
      # You can temporarily allow registration to create an admin user.
      service.DISABLE_REGISTRATION = true;
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      # Sending emails is completely optional
      # You can send a test email from the web UI at:
      # Profile Picture > Site Administration > Configuration >  Mailer Configuration
#       mailer = {
#         ENABLED = true;
#         SMTP_ADDR = "mail.example.com";
#         FROM = "noreply@${srv.DOMAIN}";
#         USER = "noreply@${srv.DOMAIN}";
#       };
    };
#     mailerPasswordFile = config.age.secrets.forgejo-mailer-password.path;
  };

  # Nginx reverse proxy
  services.nginx.virtualHosts = {
    "git.${domain}" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations = {
        "/" = {
          proxyPass = "http://localhost:8065";
        };
      };
    };
  };
}
