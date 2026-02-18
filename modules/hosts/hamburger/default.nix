{ domain, ... }:
{
  config = {
    services = {
      # don't use avahi on remote server
      avahi.enable = false;
      # don't automount USB drives on a VPS
      gvfs.enable = false;
      # disable smartd as smart monitoring isn't supported on my Hetzner VPS
      smartd.enable = false;
    };

    servers = {
      nginx = {
        enable = true;
        rootURL = {
          enable = true;
          domain = domain;
        };
      };

      rss = {
        enable = true;
        domain = "rss.${domain}";
        sopsFile = ./miniflux.yaml;
      };

      mattermost = {
        enable = true;
        domain = "chat.${domain}";
        siteName = "VoicelessCrimson";
      };

      docker = {
        enable = true;

        ntfy-sh = {
          enable = true;
          domain = "ntfy.${domain}";
          localPort = 2586;
          visitorRequestLimitExemptHosts = "70.109.49.31";
          sopsFile = ./ntfy.yaml;
        };

        vaultwarden = {
          enable = true;
          domain = "vault.${domain}";
          sopsFile = ./vaultwarden.yaml;
        };
      };
    };
  };
}
