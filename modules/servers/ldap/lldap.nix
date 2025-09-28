{ config, lib, ... }:
let
  cfg = config.servers;
in
{
  options.servers.lldap = with lib; {
    enable = mkEnableOption "Enable an opinionated lldap config.";

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be formatted as a single variable named `lldapEnvironmentVars` representing the entire lldap environment variables file.";
    };

    ldap_port = mkOption {
      type = types.port;
      description = "The port on which to have the LDAP server.";
      default = 3890;
    };

    http_port = mkOption {
      type = types.port;
      description = "The port on which to have the HTTP server, for user login and administration.";
      default = 17170;
    };
  };

  config = lib.mkIf cfg.enable {
    services.lldap = {
      enable = true;
      settings = {
        ldap_port = cfg.ldap_port;
        http_port = cfg.http_port;
      };
      environmentFile = config.sops.templates."lldapEnvironmentFile".path;
    };

    sops.secrets.lldapEnvironmentVars = {
      sopsFile = cfg.sopsFile;
      mode = "0400";
      owner = "lldap";
      group = "lldap";
    };

    sops.templates."lldapEnvironmentFile" = {
      content = ''
        ${config.sops.placeholder.lldapEnvironmentVars}
      '';
      mode = "0400";
      owner = "lldap";
      group = "lldap";
    };
  };
}
