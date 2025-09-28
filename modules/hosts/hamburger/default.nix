{ domain, ... }:
{
  config = {
    servers = {
      nginx = {
        enable = false;
        rootURL = {
          enable = true;
          domain = domain;
        };
      };
      tt-rss = {
        enable = true;
        domain = "rss.${domain}";
      };
      mattermost = {
        enable = true;
        domain = "chat.${domain}";
        siteName = "VoicelessCrimson";
      };

      # TODO: setup ntfy
     #  ntfy = {
     #    enable = true;
     #    domain = "ntfy.${domain}";
     #  };

      vaultwarden = {
        enable = true;
        domain = "vault.${domain}";
      };
    };
  };
}
