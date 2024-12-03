{ domain, pkgs, ... }:
{
  # Audiobookshelf
  services.audiobookshelf = {
    enable = true;
    port = 8066;
    package = pkgs.audiobookshelf;
  };

  # Nginx reverse proxy
  services.nginx.virtualHosts = {
    "audiobookshelf.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8066";
          proxyWebsockets = true;
        };
      };
    };
  };
}
