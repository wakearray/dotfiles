{ domain, ... }:
{
  services.tt-rss = {
    enable = true;
    # to configure a nginx virtual host directly:
    virtualHost = "rss.${domain}";
    selfUrlPath = "https://rss.${domain}";
  };
}
