{ domain, secrets, ... }:
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
        hashedPasswordFile = "${secrets}/nixos-mailserver/admin";
        aliases = [ "postmaster@${domain}" "security@${domain}" "abuse@${domain}" ];
      };
      "noreply@${domain}" = {
        hashedPasswordFile = "${secrets}/nixos-mailserver/noreply";
      };
      "kent@${domain}" = {
        hashedPasswordFile = "${secrets}/nixos-mailserver/kent";
      };
      "jess@${domain}" = {
        hashedPasswordFile = "${secrets}/nixos-mailserver/jess";
      };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
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
