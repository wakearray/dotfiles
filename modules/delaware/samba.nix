{ pkgs, ... }:
{
  users.users.sambauser = {
    isNormalUser = true;
    description = "Samba share user";
    extraGroups = [ "samba" ];
  };

  # Samba config
  services.samba-wsdd = {
    # make shares visible for Windows clients
    enable = true;
    openFirewall = true;
  };

  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      load printers = yes
      printing = cups
      printcap name = cups
      obey pam restrictions = yes
      write raw = no
      pam password change = yes
      passwd program = /usr/bin/passwd %u
      server role = standalone server
      os level = 20
      passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
      unix password sync = yes
      locking = no
      workgroup = WORKGROUP
      server string = delaware
      netbios name = delaware
      security = user
      socket options = TCP_NODELAY
      hosts allow = 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      client min protocol = SMB2
    '';
    shares = {
      printers = {
        comment = "All Printers";
        path = "/var/spool/samba";
        public = "yes";
        browseable = "yes";
        "guest ok" = "yes";
        writable = "no";
        printable = "yes";
        "create mode" = 0700;
      };
      Share_Public = {
        "path" = "/mnt/samba/share_public";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "kent" "jess" ];
        "write list" = "kent jess";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
      Share_Family = {
        "path" = "/mnt/samba/share_family";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "kent" "jess" ];
        "write list" = "kent jess";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
      Share_Friends = {
        "path" = "/mnt/samba/share_friends";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "kent" "jess" ];
        "write list" = "kent jess";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
      Personal_Kent = {
        "path" = "/mnt/samba/personal_kent";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "kent" ];
        "write list" = "kent";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
      Personal_Jess = {
        "path" = "/mnt/samba/personal_jess";
        "browseable" = "yes";
        "read only" = "no";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = [ "jess" ];
        "write list" = "jess";
        "create mask" = "0777";
        "directory mask" = "0777";
        "delete readonly" = "yes";
        "only user" = "yes";
      };
    };
  };

  # Required for samba printer sharing
  systemd.tmpfiles.rules = [
    "d /var/spool/samba 1777 root root -"
  ];

  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
}
