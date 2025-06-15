{ lib, config, pkgs, ... }:
let
  cfg = config.servers.jellyfin;
in
{
  options.servers.jellyfin = with lib; {
    enable = mkEnableOption "Enable the Jellyfin service with jellyfin-web and jellyfin-ffmpeg packages.";
  };
  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
  };
}

