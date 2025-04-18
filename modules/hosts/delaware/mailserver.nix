{ config, lib, ... }:
let
  mail = config.servers.mail;
  domain = mail.domain;
in
{
  options.servers.mail = with lib; {
    enable = mkEnableOption "Enable an opinionated mail server config using the Simple NixOS Mailserver: https://nixos-mailserver.readthedocs.io/en/latest/";

    domain = mkOption {
      type = types.str;
      default = "example.com";
      description = "The domain name used by the email server.";
    };

    users = mkOption {
      type = types.attrs;
      default = {
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
      description = "An attribute set of loginAccounts as defined here: https://nixos-mailserver.readthedocs.io/en/latest/options.html#mailserver-loginaccounts";
    };

    secrets = mkOption {
      type = types.attrs;
      default = let
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
      description = "Include the hashed password files from the SOPS /mailserver.yaml file.";
    };
  };
  config = lib.mkIf mail.enable {
    mailserver = {
      enable = true;
      fqdn = "mail.${domain}";
      domains = [ "${domain}" ];
      openFirewall = true;

      fullTextSearch = {
        enable = true;
        # index new email as they arrive
        autoIndex = true;
        enforced = "body";
      };

      # A list of all login accounts. To create the password hashes, use
      # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
      loginAccounts = mail.users;

      # Use Let's Encrypt certificates. Note that this needs to set up a stripped
      # down nginx and opens port 80.
      certificateScheme = "acme-nginx";
    };

    sops.secrets = mail.secrets;

    # mailserver.openFirewall = true; Should be opening all these ports
    #
    # networking.firewall.allowedTCPPorts = [
    #   25  # SMTP
    #   143 # IMAP
    #   465 # SMTP with TLS
    #   587 # SMTP with STARTTLS
    #   993 # IMAP with TLS
    # ];
  };
}
