{ config, lib, ... }:
let
  cfg = config.servers.authelia;
  ldap = config.servers.kanidm;
  user = config.services.authelia.instances.main.user;
in
{
  options.servers.authelia = with lib; {
    enable = mkEnableOption "Enable an opinionated Authelia config, connected to Kanidm for LDAPS.";

    listenAddress = mkOption {
      type = types.str;
      default = "";
      description = "The IP address to bind to.";
    };

    localPort = mkOption {
      type = types.port;
      default = 9091;
      description = "The port the Authelia server should be internally accessible on.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Look in module to confirm needed environment variables exist.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.authelia.instances.main = {
      enable = true;
      environmentVariables = {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = "/run/secrets/autheliaAuthenticationBackendLdapPasswordFile";
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_TLS_CERTIFICATE_CHAIN_FILE = "/var/lib/acme/${ldap.subdomain}.${ldap.domain}/fullchain.pem";
        #AUTHELIA_AUTHENTICATION_BACKEND_LDAP_TLS_PRIVATE_KEY_FILE = "";
        AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = "/run/secrets/autheliaNotifierSmtpPasswordFile";
        #AUTHELIA_NOTIFIER_SMTP_TLS_CERTIFICATE_CHAIN_FILE = "";
        #AUTHELIA_NOTIFIER_SMTP_TLS_PRIVATE_KEY_FILE = "";
        AUTHELIA_STORAGE_ENCRYPTION_KEY_FILE = "";
        #AUTHELIA_STORAGE_POSTGRES_PASSWORD_FILE = "";
        #AUTHELIA_STORAGE_POSTGRES_TLS_CERTIFICATE_CHAIN_FILE = "";
        #AUTHELIA_STORAGE_POSTGRES_TLS_PRIVATE_KEY_FILE = "";
      };

      settings = {
        default_2fa_method = "webauthn";
        server.address = "tcp://${cfg.listenAddress}:${toString cfg.localPort}";
        theme = "auto";
        authentication_backend.ldap = {
          address = "ldaps://localhost:636";
          implementation = "custom";
          base_dn = "DC=voicelesscrimson,DC=com";
          additional_users_dn = "OU=people";
          users_filter = "(&({username_attribute}={input})(objectClass=account))";
          additional_groups_dn = "ou=groups";
          groups_filter = "(&(member={dn})(objectClass=group))";
          user = "authelia";
          attributes = {
            username = "uid";
            display_name = "displayname";
            mail = "mail";
            member_of = "memberof";
          };
        };
        session = {
          name = "authelia_session";
          same_site = "lax";
          inactivity = "5m";
          expiration = "1h";
          remember_me = "1M";
          cookies = [{
            domain = "voicelesscrimson.com";
            authelia_url = "https://auth.voicelesscrimson.com";
            default_redirection_url = "https://voicelesscrimson.com";
            name = "authelia_session";
            same_site = "lax";
            inactivity = "5m";
            expiration = "1h";
            remember_me = "1d";
          }];
        };
        notifier.smtp = {
          address = "smtp://mail.smtp2go.com:2525";
          timeout = "5s";
          username = "voicelesscrimson.com";
          sender = "Authelia <authelia@voicelesscrimson.com>";
          identifier = "localhost";
          subject = "[Authelia] {title}";
          startup_check_address = "test@voicelesscrimson.com";
          disable_require_tls = "false";
          disable_starttls = "false";
          disable_html_emails = "false";
          tls = {
            server_name = "mail.smtp2go.com";
            skip_verify = "false";
            minimum_version = "TLS1.2";
            maximum_version = "TLS1.3";
          };
        };
        certificates_directory = "/etc/static/ssl/certs/";
        storage.postgres = {
          address = "unix:///var/run/postgresql";
          database = "${user}";
          username = "${user}";
        };
      };

      secrets = {
        jwtSecretFile = "/run/secrets/autheliaIdentityValidationResetPasswordJwtSecretFile";
        storageEncryptionKeyFile = "/run/secrets/autheliaStorageEncryptionKeyFile";
        sessionSecretFile = "/run/secrets/autheliaSessionSecretFile";
        oidcHmacSecretFile = "/run/secrets/autheliaOidcHmacSecretFile";
        #oidcIssuerPrivateKeyFile = "";
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [
        "${user}"
      ];
      ensureUsers = [
        {
          name = "${user}";
          ensureDBOwnership = true;
        }
      ];
      authentication = lib.mkOverride 10 ''
        # type  database  user      auth-method
        local   ${user}   ${user}   peer
      '';
    };

    users.users."${user}" = {
      isSystemUser = true;
      group = "${user}";
      extraGroups = [
        # Needed for reading certs
        "nginx"
        # Needed for manipulating database
        "postgres"
      ];
    };

    users.groups.authelia = {};

    sops.secrets = let
      opts = {
        sopsFile = cfg.sopsFile;
        mode = "0400";
        owner = user;
        group = config.services.authelia.instances.main.group;
      };
    in {
      autheliaAuthenticationBackendLdapPasswordFile = opts;
      autheliaIdentityValidationResetPasswordJwtSecretFile = opts;
      autheliaStorageEncryptionKeyFile = opts;
      autheliaSessionSecretFile = opts;
      autheliaNotifierSmtpPasswordFile = opts;
    };
  };
}
