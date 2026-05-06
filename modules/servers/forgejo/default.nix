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

    subdomain = mkOption {
      type = types.str;
      default = "git";
      description = "The subdomain that your server will be hosted at.";
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
      settings = {
        server = {
          DOMAIN = "localhost";
          ROOT_URL = "https://${cfg.subdomain}.${cfg.domain}/";
          PROTOCOL = "http";
          HTTP_PORT = cfg.localPort;
        };
        # You can temporarily allow registration to create an admin user.
        service = {
          DISABLE_REGISTRATION = cfg.disableRegistration;
          ALLOW_ONLY_EXTERNAL_REGISTRATION = cfg.disableRegistration;
          #ENABLE_PASSWORD_SIGNIN_FORM = false;
          #ENABLE_BASIC_AUTHENTICATION = false;
        };
        openid = {
          ENABLE_OPENID_SIGNIN = false;
        };

        oauth2_client = {
          #
          # Scopes for the openid connect oauth2 provider (separated by space, the openid scope is implicitly added).
          # Typical values are profile and email.
          # For more information about the possible values see https://openid.net/specs/openid-connect-core-1_0.html#ScopeClaims
          OPENID_CONNECT_SCOPES = "email profile ssh_publickeys";
          #
          # Update avatar if available from oauth2 provider.
          # Update will be performed on each login.
          UPDATE_AVATAR = true;
          #
          # Whether a new auto registered oauth2 user needs to confirm their email.
          # Do not include to use the REGISTER_EMAIL_CONFIRM setting from the `[service]` section.
          REGISTER_EMAIL_CONFIRM = false;
          #
          # Automatically create user accounts for new oauth2 users.
          ENABLE_AUTO_REGISTRATION = true;
          #
          # The source of the username for new oauth2 accounts:
          # userid = use the userid / sub attribute
          # nickname = use the nickname attribute
          # email = use the username part of the email attribute
          # Note: `nickname` and `email` options will normalize input strings using the following criteria:
          # - diacritics are removed
          # - the characters in the set `['´\x60]` are removed
          # - the characters in the set `[\s~+]` are replaced with `-`
          USERNAME = "nickname";
          #
          # How to handle if an account / email already exists:
          # disabled = show an error
          # login = show an account linking login
          # auto = link directly with the account
          ACCOUNT_LINKING = "login";

        };
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
          USER = "${cfg.domain}";
          PASSWD_URI = "file:/run/secrets/forgejo_mailer_password";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.localPort ];

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
  };
}

