{ config, lib, ... }:
let
  cfg = config.servers.mail;
in
{
  # Make sure to include `simple-nixos-mailserver.nixosModule` in the flake modules for the host you want to use this with.
  options.servers.mail = with lib; {
    enable = mkEnableOption "Enable an opinionated mail server config using the Simple NixOS Mailserver: https://nixos-mailserver.readthedocs.io/en/latest/";

    smtp.enable = mkEnableOption "Whether to enable sending of mail.";
    imap.enable = mkEnableOption "Whether to enable recieving of mail using IMAP.";

    domain = mkOption {
      type = types.str;
      default = "example.com";
      description = "The domain name used by the email server.";
    };

    users = mkOption {
      type = types.attrs;
      default = {
        "admin@${cfg.domain}" = {
          hashedPasswordFile = "/run/secrets/mail-server-admin";
          aliases = [ "postmaster@${cfg.domain}" "security@${cfg.domain}" "abuse@${cfg.domain}" ];
        };
        "noreply@${cfg.domain}" = {
          hashedPasswordFile = "/run/secrets/mail-server-noreply";
        };
        "kent@${cfg.domain}" = {
          hashedPasswordFile = "/run/secrets/mail-server-kent";
        };
        "jess@${cfg.domain}" = {
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
  config = lib.mkIf cfg.enable {
    mailserver = {
      enable = true;
      fqdn = "mail.${cfg.domain}";
      domains = [ "${cfg.domain}" ];
      openFirewall = true;

      enableImap = cfg.imap.enable;
      enableImapSsl = cfg.imap.enable;

      enableSubmission = cfg.smtp.enable;
      enableSubmissionSsl = cfg.smtp.enable;

      fullTextSearch = {
        enable = true;
        # index new email as they arrive
        autoIndex = true;
        enforced = "body";
      };

      # A list of all login accounts. To create the password hashes, use
      # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
      loginAccounts = cfg.users;

      # Use Let's Encrypt certificates. Note that this needs to set up a stripped
      # down nginx and opens port 80.
      certificateScheme = "acme-nginx";

      stateVersion = 3;
    };

    sops.secrets = cfg.secrets;

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
