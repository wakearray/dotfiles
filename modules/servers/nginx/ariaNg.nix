{ pkgs, lib, config, ... }:
let
  cfg = config.servers.nginx.ariaNg;
in
{
  options.servers.nginx.ariaNg = with lib; {
    enable = mkEnableOption "Enable an nginx reverse proxy server supporting AriaNg.";

    domain = mkOption {
      type = types.str;
      default = config.servers.nginx.domain;
      description = "The domain you want AriaNg hosted at.";
    };

    subdomain = mkOption {
      type = types.str;
      default = "aria2";
      description = "The subdomain that AriaNg will be hosted at.";
    };

    localPort = mkOption {
      type = types.port;
      default = 6800;
      description = "The rpc-listen-port for your Aria2 server. To use the port of another host use `self.nixosConfigurations.Delaware.config.services.aria2.settings.rpc-listen-port` replacing `Delaware` with the host configuration Aria2 is being run on.";
    };

    localIP = mkOption {
      type = types.str;
      default = "localhost";
      description = "The local network IP address of the Aria2 server. Use `localhost` or `127.0.0.1` if server is running on the same host as the nginx reverse proxy.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Frontend for Aria2
    environment.systemPackages = [ pkgs.ariang ];

    # Nginx reverse proxy
    services.nginx.virtualHosts = {
      "${cfg.subdomain}.${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            root = "${pkgs.ariang}/share/ariang";
          };
          "/jsonrpc" = {
            proxyPass = "http://${cfg.localIP}:${toString cfg.localPort}";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
