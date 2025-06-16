{ lib, config, pkgs, ... }:
let
  aria = config.servers.aria2;
in
{
  options.servers.aria2 = with lib; {
    enable = mkEnableOption "Enable an Aria2 server with Ariang frontend.";

    rpcSopsFile = mkOption {
      type = types.path;
      default = ./aria2.yaml;
      description = "The location of the SOPS yaml file that includes the RPC secret token.";
    };

    downloadsDirectory = mkOption {
      type = types.str;
      default = "/var/lib/aria2/Downloads";
      description = "Directory to store downloaded files.";
    };

    listenPorts = mkOption {
      type = with lib.types; listOf (attrsOf port);
      default = [{
        from = 6881;
        to = 6999;
      }];
      description = "Set UDP listening port range used by DHT(IPv4, IPv6) and UDP tracker.";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      default = "aria.example.com";
      description = "The domain you want to access AriaNg from.";
    };
  };

  config = lib.mkIf aria.enable {
    services.aria2 = {
      enable = true;
      settings = {
        # Generates the aria2.conf file. Refer to the documentation for all possible settings.
        # attribute set of (boolean or signed integer or floating point number or (optionally newline-terminated) single-line string)
        dir = aria.downloadsDirectory;
        listen-port = aria.listenPorts;
        rpc-listen-port = 6800;
      };
      rpcSecretFile = "/run/secrets/aria2-rpc-token";
      serviceUMask = "0002";
      openPorts = true;
    };

    # Frontend for Aria2
    environment.systemPackages = [ pkgs.ariang ];

    # Nginx server
    services.nginx.virtualHosts."${aria.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          root = "${pkgs.ariang}/share/ariang";
        };
        "/jsonrpc" = {
          proxypass = "http://localhost:${toString config.services.aria2.settings.rpc-listen-port}";
          proxyWebsockets = true;
        };
      };
    };

    # RPC token
    sops.secrets.aria2-rpc-token = {
      sopsFile = aria.rpcSopsFile;
      mode     = "0400";
      owner    = "aria2";
      group    = "aria2";
    };
  };
}
