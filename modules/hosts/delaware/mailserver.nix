{ domain, ... }:
{
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
    loginAccounts = {
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

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };

  sops = {
    secrets = {
      mail-server-admin = { sopsFile = ./mailserver.yaml; };
      mail-server-noreply = { sopsFile = ./mailserver.yaml; };
      mail-server-kent = { sopsFile = ./mailserver.yaml; };
      mail-server-jess = { sopsFile = ./mailserver.yaml; };
    };
  };


   # mailserver.openFirewall = true; Should be opening all these ports
   #
   # networking.firewall.allowedTCPPorts = [
   #   25  # SMTP
   #   143 # IMAP
   #   465 # SMTP with TLS
   #   587 # SMTP with STARTTLS
   #   993 # IMAP with TLS
   # ];
}
