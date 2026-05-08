{ lib, config, ... }:
let
  cfg = config.servers.docker.vaultwarden;
in
{
  options.servers.docker.vaultwarden = with lib; {
    enable = mkEnableOption "Enable an opinionated vaultwarden config.";

    domain = mkOption {
      type = types.str;
      default = config.servers.nginx.domain;
      description = "The domain you want vaultwarden hosted at.";
    };

    subdomain = mkOption {
      type = types.str;
      default = "vault";
      description = "The subdomain you want vaultwarden hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 8222;
      description = "The local port you want vaultwarden hosted at.";
    };

    dataFolder = mkOption {
      type = types.str;
      default = "/var/lib/vaultwarden/";
      description = "String of path to where you want the vault to be located.";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be a complete environment file named `vaultwardenEnvironmentVars` including (but not limited to) `PUSH_INSTALLATION_ID`, `PUSH_INSTALLATION_KEY`, and `ADMIN_TOKEN`.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.vaultwarden = {
      image = "vaultwarden/server:latest";
      autoStart = true;
      environmentFiles = [
        config.sops.templates."vaultwardenEnvironmentFile.env".path
      ];
      volumes = [
        "${cfg.dataFolder}:/data/"
      ];
      ports = let port = toString cfg.localPort; in [
        "127.0.0.1:${port}:${port}"
      ];
    };

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "${cfg.subdomain}.${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.localPort}";
            proxyWebsockets = true;
          };
        };
      };
    };

    # Docker Container Update Timer
    systemd.services."updateVaultwardenDockerImage" = {
      description = "Pull latest Docker image and restart services";
      path = [ config.virtualisation.docker.package ];
      script = ''
        docker pull vaultwarden/server:latest
        systemctl restart docker-vaultwarden.service
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    # Define the timer
    systemd.timers.updateVaultwardenDockerImageTimer = {
      description = "Daily timer to pull latest Docker image for Vaultwarden and restart services";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "06:00:00";
        Persistent = true; # Ensures the timer catches up if it missed a run
        Unit = "updateVaultwardenDockerImage.service";
      };
    };

    # sops secrets
    sops.secrets = {
      vw_push_id = { sopsFile = cfg.sopsFile; };
      vw_push_key = { sopsFile = cfg.sopsFile; };
      vw_admin_token = { sopsFile = cfg.sopsFile; };
      vw_sso_client_secret = { sopsFile = cfg.sopsFile; };
    };

    sops.templates."vaultwardenEnvironmentFile.env" = {
      content  = ''
        PUSH_ENABLED=true
        PUSH_INSTALLATION_ID=${config.sops.placeholder.vw_push_id}
        PUSH_INSTALLATION_KEY=${config.sops.placeholder.vw_push_key}
        ADMIN_TOKEN=${config.sops.placeholder.vw_admin_token}

        DOMAIN=https://${cfg.subdomain}.${cfg.domain}
        SIGNUPS_ALLOWED=false
        ROCKET_PORT=${toString cfg.localPort}
        ROCKET_LOG=critical


        # Activate the SSO
        SSO_ENABLED=true
        # disable email+Master password authentication
        SSO_ONLY=false
        # On SSO Signup if a user with a matching email already exists make the association (default true)
        SSO_SIGNUPS_MATCH_EMAIL=true
        # Allow unknown email verification status (default false). Allowing this with SSO_SIGNUPS_MATCH_EMAIL open potential account takeover.
        SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION=false

        # The OpenID Connect Discovery endpoint of your SSO
        # The URL must not include the /.well-known/openid-configuration
        # <OIDC_URL>/.well-known/openid-configuration must return a JSON document
        # SSO_AUTHORITY has to match the exact value of the issuer field that is returned by that JSON
        # (so take the issuer value of the file if you are unsure whether to include a trailing slash or not).
        SSO_AUTHORITY=https://idm.voicelesscrimson.com/oauth2/openid/vaultwarden
        # Activate PKCE for the Auth Code flow (default true).
        SSO_PKCE=true
        # Client Id
        SSO_CLIENT_ID=vaultwarden
        # Client Secret
        SSO_CLIENT_SECRET=${config.sops.placeholder.vw_sso_client_secret}

        # Optional, allow to override scopes if needed (default profile email, openid is implicit)
        #SSO_SCOPES=
        # Optional, allow to add extra parameter to the authorize redirection (default "")
        #SSO_AUTHORIZE_EXTRA_PARAMS=
        # Optional, Regex to trust additional audience for the IdToken
        # (client_id is always trusted). Use single quote when writing the regex: '^$'.
        #SSO_AUDIENCE_TRUSTED=

        # Enable to use SSO only for authentication not session lifecycle
        SSO_AUTH_ONLY_NOT_SESSION=false
        # Cache calls to the discovery endpoint, duration in seconds, 0 to disable (default 0);
        SSO_CLIENT_CACHE_EXPIRATION=0
        # Log all tokens for easier debugging
        # (default false, LOG_LEVEL=debug or LOG_LEVEL=info,vaultwarden::sso=debug need to be set)
        SSO_DEBUG_TOKENS=false


        EXPERIMENTAL_CLIENT_FEATURE_FLAGS=ssh-key-vault-item,ssh-agent,mutual-tls
      '';
    };
  };
}
