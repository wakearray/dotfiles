{ config, lib, ... }:
let
  cfg = config.servers.lldap;
in
{
  options.servers.lldap = with lib; {
    enable = mkEnableOption "Enable an opinionated lldap config.";

    domain = mkOption {
      type = types.str;
      default = "example.com";
      description = "External domain name. Will add ldap infront. E.g. ldap.example.com";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be formatted as a single variable named `lldapEnvironmentVars` representing the entire lldap environment variables file.";
    };

    ldapPort = mkOption {
      type = types.port;
      description = "The port on which to have the LDAP server.";
      default = 3890;
    };

    httpPort = mkOption {
      type = types.port;
      description = "The port on which to have the HTTP server, for user login and administration.";
      default = 17170;
    };

    LDAPS = {
      enable = mkEnableOption "Enable LDAP over SSL/TLS";

      port = mkOption {
        type = types.port;
        description = "Default LDAPS ports are 636 and 6360.";
        default = 6360;
      };

      dnsProvider = mkOption {
        type = types.str;
        description = "Name of your DNS provider, such as `route53` or `cloudflare`";
        default = "cloudflare";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.lldap = {
      enable = true;
      settings = {
        ldap_base_dn = "dc=${toString (lib.sublist 0 1 (lib.splitStringBy (prev: curr: builtins.elem curr [ "." ]) false cfg.domain))},dc=${toString (lib.sublist 1 2 (lib.splitStringBy (prev: curr: builtins.elem curr [ "." ]) false cfg.domain))}";
        ldap_user_pass_file = "/run/secrets/ldap_user_pass";
        force_ldap_user_pass_reset = "always";
      };
      environmentFile = config.sops.templates."lldapEnvironmentFile".path;
    };

    # Create the lldap user and group because the lldap module won't, apparently.
    users = {
      groups.lldap = {};
      users."lldap" = {
        isSystemUser = true;
        group = "lldap";
        extraGroups = [ "acme" ];
      };
    };

    networking.firewall.allowedTCPPorts = [
      cfg.httpPort
    ] ++ lib.optionals cfg.LDAPS.enable [
      cfg.LDAPS.port
    ] ++ lib.optionals (!cfg.LDAPS.enable) [
      cfg.ldapPort
    ];

    # Nginx reverse proxy
    services.nginx.virtualHosts."lldap.${cfg.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.httpPort}";
        proxyWebsockets = true;
      };
    };

    security.acme.certs."ldap.${cfg.domain}" = lib.mkIf cfg.LDAPS.enable {
      domain = "ldap.${cfg.domain}";
      dnsProvider = "${cfg.LDAPS.dnsProvider}";
      credentialsFile = "/run/secrets/dns_edit_token"; # Absolute path to your secret file
      group = "acme";
      postRun =  ''
        systemctl restart lldap.service
      '';
    };

    # Might allow lldap to see the certs it needs for LDAPS
    systemd.services.lldap.serviceConfig = {
      # Grant the service filesystem access to the ACME directory
      ReadOnlyPaths = [ "/var/lib/acme" "/var/lib/acme/ldap.${cfg.domain}" ];
      # Ensure the group membership is respected inside the service sandbox
      SupplementaryGroups = [ "acme" ];
    };

    sops.secrets = let
      opts = {
        sopsFile = cfg.sopsFile;
        mode = "0400";
        owner = "lldap";
        group = "lldap";
      };
    in
    {
      lldap_jwt_secret = opts;
      ldap_user_pass = opts;
      LLDAP_KEY_SEED = opts;
      LLDAP_LDAP_USER_DN = opts;
      LLDAP_SMTP_OPTIONS__SERVER = opts;
      LLDAP_SMTP_OPTIONS__USER = opts;
      LLDAP_SMTP_OPTIONS__PASSWORD = opts;
      LLDAP_SMTP_OPTIONS__FROM = opts;
      LLDAP_SMTP_OPTIONS__REPLY_TO = opts;
      dns_edit_token = opts;
    };

    sops.templates."lldapEnvironmentFile" = {
      content = /*bash*/ ''
        ## Tune the logging to be more verbose by setting this to be true.
        LLDAP_VERBOSE=true

        ## The host address that the LDAP server will be bound to.
        ## To enable IPv6 support, simply switch "ldap_host" to "::":
        ## To only allow connections from localhost (if you want to restrict to local self-hosted services),
        ## change it to "127.0.0.1" ("::1" in case of IPv6).
        ## If LLDAP server is running in docker, set it to "0.0.0.0" ("::" for IPv6) to allow connections
        ## originating from outside the container.
        LLDAP_LDAP_HOST="0.0.0.0"

        ## The port on which to have the LDAP server.
        LLDAP_LDAP_PORT=${toString cfg.ldapPort}

        ## The host address that the HTTP server will be bound to.
        ## To enable IPv6 support, simply switch "http_host" to "::".
        ## To only allow connections from localhost (if you want to restrict to local self-hosted services),
        ## change it to "127.0.0.1" ("::1" in case of IPv6).
        ## If LLDAP server is running in docker, set it to "0.0.0.0" ("::" for IPv6) to allow connections
        ## originating from outside the container.
        LLDAP_HTTP_HOST="0.0.0.0"

        ## The port on which to have the HTTP server, for user login and
        ## administration.
        LLDAP_HTTP_PORT=${toString cfg.httpPort}

        ## The public URL of the server, for password reset links.
        LLDAP_HTTP_URL="https://ldap.${toString cfg.domain}"

        ## The path to the front-end assets (relative to the working directory).
        #LLDAP_ASSETS_PATH="./app"

        ## Random secret for JWT signature.
        ## This secret should be random, and should be shared with application
        ## servers that need to consume the JWTs.
        ## Changing this secret will invalidate all user sessions and require
        ## them to re-login.
        ## You can generate it with (on linux):
        ## LC_ALL=C tr -dc 'A-Za-z0-9!#%&()*+,-./:;<=>?@[\]^_{|}~' </dev/urandom | head -c 32; echo ""
        LLDAP_JWT_SECRET_FILE="/run/secrets/lldap_jwt_secret"

        ## Base DN for LDAP.
        ## This is usually your domain name, and is used as a
        ## namespace for your users. The choice is arbitrary, but will be needed
        ## to configure the LDAP integration with other services.
        ## The sample value is for "example.com", but you can extend it with as
        ## many "dc" as you want, and you don't actually need to own the domain
        ## name.
        #LLDAP_LDAP_BASE_DN="dc=${toString (lib.sublist 0 1 (lib.splitStringBy (prev: curr: builtins.elem curr [ "." ]) false cfg.domain))},dc=${toString (lib.sublist 1 2 (lib.splitStringBy (prev: curr: builtins.elem curr [ "." ]) false cfg.domain))}"

        ## Admin username.
        ## For the LDAP interface, a value of "admin" here will create the LDAP
        ## user "cn=admin,ou=people,dc=example,dc=com" (with the base DN above).
        ## For the administration interface, this is the username.
        LLDAP_LDAP_USER_DN="${config.sops.placeholder.LLDAP_LDAP_USER_DN}"

        ## Admin email.
        ## Email for the admin account. It is only used when initially creating
        ## the admin user, and can safely be omitted.
        LLDAP_LDAP_USER_EMAIL="${config.sops.placeholder.LLDAP_LDAP_USER_DN}@${toString cfg.domain}"

        ## Admin password.
        ## Password for the admin account, both for the LDAP bind and for the
        ## administration interface. It is only used when initially creating
        ## the admin user.
        ## It should be minimum 8 characters long.
        ## You can set it with the LLDAP_LDAP_USER_PASS environment variable.
        ## This can also be set from a file's contents by specifying the file path
        ## in the LLDAP_LDAP_USER_PASS_FILE environment variable
        ## Note: you can create another admin user for user administration, this
        ## is just the default one.
        #LLDAP_LDAP_USER_PASS_FILE="/run/secrets/ldap_user_pass"

        ## Force reset of the admin password.
        ## Break glass in case of emergency: if you lost the admin password, you
        ## can set this to true to force a reset of the admin password to the value
        ## of ldap_user_pass above.
        ## Alternatively, you can set it to "always" to reset every time the server starts.
        LLDAP_FORCE_LDAP_USER_PASS_RESET=false

        ## Private key file.
        ## Not recommended, use key_seed instead.
        ## Contains the secret private key used to store the passwords safely.
        ## Note that even with a database dump and the private key, an attacker
        ## would still have to perform an (expensive) brute force attack to find
        ## each password.
        ## Randomly generated on first run if it doesn't exist.
        LLDAP_KEY_FILE=

        ## Seed to generate the server private key, see key_file above.
        ## This can be any random string, the recommendation is that it's at least 12
        ## characters long.
        LLDAP_KEY_SEED="${config.sops.placeholder.LLDAP_KEY_SEED}"

        ## Ignored attributes.
        ## Some services will request attributes that are not present in LLDAP. When it
        ## is the case, LLDAP will warn about the attribute being unknown. If you want
        ## to ignore the attribute and the service works without, you can add it to this
        ## list to silence the warning.
        LLDAP_IGNORED_USER_ATTRIBUTES=[ "sAMAccountName" ]
        LLDAP_IGNORED_GROUP_ATTRIBUTES=[ "mail", "userPrincipalName" ]

        # [smtp_options]
        ## Options to configure SMTP parameters, to send password reset emails.

        ## Whether to enabled password reset via email, from LLDAP.
        LLDAP_SMTP_OPTIONS__ENABLE_PASSWORD_RESET=true
        ## The SMTP server.
        LLDAP_SMTP_OPTIONS__SERVER="${config.sops.placeholder.LLDAP_SMTP_OPTIONS__SERVER}"
        ## The SMTP port.
        LLDAP_SMTP_OPTIONS__PORT=587
        ## How the connection is encrypted, either "NONE" (no encryption), "TLS" or "STARTTLS".
        LLDAP_SMTP_OPTIONS__SMTP_ENCRYPTION="TLS"
        ## The SMTP user, usually your email address.
        LLDAP_SMTP_OPTIONS__USER="${config.sops.placeholder.LLDAP_SMTP_OPTIONS__USER}"
        ## The SMTP password.
        LLDAP_SMTP_OPTIONS__PASSWORD="${config.sops.placeholder.LLDAP_SMTP_OPTIONS__PASSWORD}"
        ## The header field, optional: how the sender appears in the email. The first
        ## is a free-form name, followed by an email between <>.
        LLDAP_SMTP_OPTIONS__FROM="${config.sops.placeholder.LLDAP_SMTP_OPTIONS__FROM}"
        ## Same for reply-to, optional.
        LLDAP_SMTP_OPTIONS__REPLY_TO="${config.sops.placeholder.LLDAP_SMTP_OPTIONS__REPLY_TO}"

        ${lib.optionalString cfg.LDAPS.enable /*bash*/ ''
        # [ldaps_options]
        ## Options to configure LDAPS.

        ## Whether to enable LDAPS.
        LLDAP_LDAPS_OPTIONS__ENABLED=true
        ## Port on which to listen.
        LLDAP_LDAPS_OPTIONS__PORT=${toString cfg.LDAPS.port}
        ## Certificate file.
        LLDAP_LDAPS_OPTIONS__CERT_FILE="/var/lib/acme/lldap.${cfg.domain}/cert.pem"
        ## Certificate key file.
        LLDAP_LDAPS_OPTIONS__KEY_FILE="/var/lib/acme/lldap.${cfg.domain}/key.pem"
        ''
        }
      '';
      mode = "0400";
      owner = "lldap";
      group = "lldap";
    };
  };
}
