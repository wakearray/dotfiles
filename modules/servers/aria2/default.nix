{ lib, config, ... }:
let
  cfg = config.servers.aria2;
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

    localPort = mkOption {
      type = types.port;
      default = 6800;
      description = "The local port that Aria2 apps will connect to the server on.";
    };

    sameServerHost = mkEnableOption "If false, localPort will be exposed, if true it won't be.";
  };

  config = lib.mkIf cfg.enable {
    services.aria2 = {
      enable = true;
      settings = {
        # Generates the aria2.conf file. Refer to the documentation for all possible settings.
        # attribute set of (boolean or signed integer or floating point number or (optionally newline-terminated) single-line string)
        dir = cfg.downloadsDirectory;
        listen-port = cfg.listenPorts;
        rpc-listen-port = cfg.localPort;
      };
      rpcSecretFile = "/run/secrets/aria2-rpc-token";
      serviceUMask = "0002";
      openPorts = true;
    };

    networking.firewall.allowedTCPPorts = [] ++ lib.optionals (!cfg.sameServerHost) [ cfg.localPort ];

    # RPC token
    sops.secrets.aria2-rpc-token = {
      sopsFile = cfg.rpcSopsFile;
      mode     = "0400";
      owner    = "aria2";
      group    = "aria2";
    };
  };
}
