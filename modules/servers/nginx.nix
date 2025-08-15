{ lib, config, ... }:
let
  cfg = config.servers.nginx;
in
{
  options.servers.nginx = with lib; {
    enable = mkEnableOption "Enable nginx";

    sshRedirection = {
      enable = mkEnableOption "Enable connecting to ssh over port 443. Needed when using something like ";

      port = mkOption {
        type = types.port;
        default = 443;
        description = "The port that remote SSH connections should come in on.";
      };
    };

    domain = mkOption {
      type = types.str;
      default = "example.com";
    };
  };

  config = lib.mkIf cfg.enable {
    # Nginx reverse proxy
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        # Additional virtualHosts can be found with their respective services config files.
        "${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          root = "/var/www/${cfg.domain}";
        };
      };
      streamConfig = lib.mkIf cfg.sshRedirection.enable ''
        # Optional: Log stream connections
        log_format basic '$remote_addr [$time_local] '
                         '$protocol $status $bytes_sent $bytes_received '
                         '$session_time';
        access_log /var/log/nginx/stream_access.log basic;

        server {
            listen ${cfg.sshRedirection.port}; # Or your desired port for SSH
            proxy_pass 127.0.0.1:22; # Or the IP and port of your SSH server
            # Other stream-specific configurations like proxy_timeout, etc.
        }
      '';
    };

    users.users.nginx.extraGroups = [ "acme" ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "kent.hambrock@gmail.com";
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
