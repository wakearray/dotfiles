{ config, lib, ... }:
let
  cfg = config.servers.ncps;
in
{
  options.servers.ncps = with lib; {
    enable = mkEnableOption "Enable an opinionated [`ncps`](https://github.com/kalbasit/ncps) config. `ncps` is a nix binary cache proxy service with local caching and signing.";

    storageLocation = mkOption {
      type = types.str;
      default = "/var/lib/ncps";
      description = "The location where the `data`, `tmp`, and `db` directories will be located.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ncps = {
      enable = true;
      cache = {
        hostName = "Delaware";
        dataPath = "${cfg.storageLocation}";
        databaseURL = "sqlite:${cfg.storageLocation}/db/db.sqlite";
        maxSize = "50G";
        lru.schedule = "0 4 1 * *"; # Clean up on the first of every month at 4 AM
        allowPutVerb = true;
        allowDeleteVerb = true;
      };
      server.addr = "0.0.0.0:8501";
      upstream = {
        caches = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        publicKeys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };
    networking.firewall = {
      allowedTCPPorts = [ 8501 ];
      allowedUDPPorts = [ 8501 ];
    };
  };
}
