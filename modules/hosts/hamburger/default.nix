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
        users = {
          "admin@${domain}" = {
            hashedPasswordFile = "/run/secrets/mail-server-admin";
            aliases = [ "postmaster@${domain}" "security@${domain}" "abuse@${domain}" ];
          };
          "noreply@${domain}" = {
            hashedPasswordFile = "/run/secrets/mail-server-noreply";
          };
          "kent@${domain}" = {
            hashedPasswordFile = "/run/secrets/mail-server-kent";
          };
          "jess@${domain}" = {
            hashedPasswordFile = "/run/secrets/mail-server-jess";
          };
        };
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
