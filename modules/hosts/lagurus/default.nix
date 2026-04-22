{ domain, ... }:
let
  devices = import ../../devices.nix;
  serverIP = devices.delaware.ip;
in
{
  # modules/hosts/lagurus
  config = {
    servers = {
      authelia = {
        enable = true;
        sopsFile = ./authelia.yaml;
      };
      nginx = {
        enable = true;
        domain = domain;
        ariaNg = {
          enable = true;
          localIP = serverIP;
        };
        audiobookshelf = {
          enable = true;
          localIP = serverIP;
        };
        authelia = {
          enable = true;
        };
        forgejo = {
          enable = true;
          localIP = serverIP;
        };
        paperless = {
          enable = true;
          localIP = serverIP;
        };
      };
      kanidm = {
        enable = true;
        domain = domain;
      };
    };
    services = {
      # Smartd doesn't work on Lagurus
      smartd.enable = false;
      # Don't auto mount USB drives on the LDAP/IdP server
      gvfs.enable = false;
    };
  };
}
