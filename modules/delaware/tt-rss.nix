{ domain, ... }:
{
  services.tt-rss = {
    enable = true;
    selfUrlPath = "http://localhost:8064";
  };

  # Nginx reverse proxy
  services.nginx.virtualHosts = {
    "rss.${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations = {
        "/" = {
          proxyPass = "http://localhost:8064";
        };
      };
    };
  };
}
