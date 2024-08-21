{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  mailserver = {
    enable = true;
    fqdn = "mail.${config.domain}";
    domains = [ "${config.domain}" ];
    openFirewall = true;

    fullTextSearch = {
      enable = true;
      # index new email as they arrive
      autoIndex = true;
      # this only applies to plain text attachments, binary attachments are never indexed
      indexAttachments = true;
      enforced = "body";
    };

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "admin@${config.domain}" = {
        hashedPasswordFile = "${config.secrets}/nixos-mailserver/admin";
        aliases = [ "postmaster@${config.domain}" "security@${config.domain}" "abuse@${config.domain}" ];
      };
      "noreply@${config.domain}" = {
        hashedPasswordFile = "${config.secrets}/nixos-mailserver/noreply";
      };
      "kent@${config.domain}" = {
        hashedPasswordFile = "${config.secrets}/nixos-mailserver/kent";
      };
      "jess@${config.domain}" = {
        hashedPasswordFile = "${config.secrets}/nixos-mailserver/jess";
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
