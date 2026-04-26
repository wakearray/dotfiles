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
        domain = domain;
        rootURL.enable = true;
        mealie.enable = true;
        miniflux.enable = true;
      };

      mattermost = {
        enable = true;
        domain = domain;
        siteName = "VoicelessCrimson";
      };

      miniflux = {
        enable = true;
        sopsFile = ./miniflux.yaml;
      };

      docker = {
        enable = true;

        ntfy-sh = {
          enable = true;
          domain = domain;
          localPort = 2586;
          visitorRequestLimitExemptHosts = "70.109.49.31";
          sopsFile = ./ntfy.yaml;
        };

        mealie = {
          enable = true;
          domain = domain;
          sopsFile = ./mealie.yaml;
        };

        vaultwarden = {
          enable = true;
          domain = domain;
          sopsFile = ./vaultwarden.yaml;
        };
      };
    };
  };
}
