{ lib, config, pkgs, ... }:
let
  cfg = config.servers.audiobookshelf;
in
{
  # AudioBookShelf
  # https://www.audiobookshelf.org/docs

  options.servers.audiobookshelf = with lib; {
    enable = mkEnableOption "Enable opinionated AudioBookShelf install.";

    localPort = mkOption {
      type = types.port;
      default = 8066;
      description = "The local port where AudioBookShelf can be accessed.";
    };

    sameServerHost = mkEnableOption "If false, localPort will be exposed, if true it won't be.";
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      port = cfg.localPort;
      package = pkgs.audiobookshelf;
      host = "0.0.0.0";
    };

    networking.firewall.allowedTCPPorts = [ ] ++ lib.optionals (!cfg.sameServerHost) [ cfg.localPort ];
  };
}
