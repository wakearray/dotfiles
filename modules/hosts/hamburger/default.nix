{ domain, ... }:
{
  config = {
    servers = {
      nginx = {
        enable = true;
        domain = domain;
      };
      mail = {
        enable = true;
        domain = domain;
        secrets = let
          opts = {
            sopsFile = ./mailserver.yaml;
            mode     = "0400";
            owner    = "virtualMail";
            group    = "virtualMail";
          };
        in
        {
          mail-server-admin = opts;
          mail-server-noreply = opts;
          mail-server-kent = opts;
          mail-server-jess = opts;
        };
      };
    };
  };
}
