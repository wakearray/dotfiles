{ config, lib, ... }:
let
  cfg = config.docker.lldap;
in
{
  options.docker.lldap = with lib; {
    enable = mkEnableOption "Enable a docker based lldap config";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.lldap = {
      image = "lldap/lldap:stable";

      # Published ports
      ports = [
        # Web front-end
        "17170:17170"
        # LDAP (not recommended to expose)
        # "3890:3890"
        # LDAPS (enable if you set LLDAP_LDAPS_OPTIONS__ENABLED=true below)
        # "6360:6360"
      ];

      # Volumes: a named volume like in compose; the backend will create it if missing.
      # Alternatively, replace with "/path/on/host:/data" to bind-mount a host directory.
      volumes = [
        "lldap_data:/data"
        # "/path/to/lldap_data:/data"
      ];

      # Environment
      environment = {
        UID = "####";
        GID = "####";
        TZ = "####/####";
        LLDAP_JWT_SECRET = "REPLACE_WITH_RANDOM";
        LLDAP_KEY_SEED = "REPLACE_WITH_RANDOM";
        LLDAP_LDAP_BASE_DN = "dc=example,dc=com";
        LLDAP_LDAP_USER_PASS = "CHANGE_ME";
        # If using LDAPS, uncomment and set:
        # LLDAP_LDAPS_OPTIONS__ENABLED = "true";
        # LLDAP_LDAPS_OPTIONS__CERT_FILE = "/path/to/certfile.crt";
        # LLDAP_LDAPS_OPTIONS__KEY_FILE = "/path/to/keyfile.key";

        # Optional: choose a different database
        # LLDAP_DATABASE_URL = "mysql://mysql-user:password@mysql-server/my-database";
        # LLDAP_DATABASE_URL = "postgres://postgres-user:password@postgres-server/my-database";

        # Optional: SMTP settings
        # LLDAP_SMTP_OPTIONS__ENABLE_PASSWORD_RESET = "true";
        # LLDAP_SMTP_OPTIONS__SERVER = "smtp.example.com";
        # LLDAP_SMTP_OPTIONS__PORT = "465";
        # LLDAP_SMTP_OPTIONS__SMTP_ENCRYPTION = "TLS"; # NONE | TLS | STARTTLS
        # LLDAP_SMTP_OPTIONS__USER = "no-reply@example.com";
        # LLDAP_SMTP_OPTIONS__PASSWORD = "PasswordGoesHere";
        # LLDAP_SMTP_OPTIONS__FROM = "no-reply <no-reply@example.com>";
        # LLDAP_SMTP_OPTIONS__TO = "admin <admin@example.com>";
      };

      # Optional: pick a backend explicitly (defaults to podman on recent NixOS)
      # serviceName = "podman-lldap";
      # pull = "missing"; # default
      # autoStart = true; # default
    };

    # If you prefer Docker instead of Podman:
    # virtualisation.oci-containers.backend = "docker";
  };
}
