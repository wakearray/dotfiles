{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let
  remote = "192.168.0.46";
in
{
  # Samba
  fileSystems = {
    "/mnt/Share_Public" = {
      device = "//${remote}/Share_Public";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
    "/mnt/Share_Family" = {
      device = "//${remote}/Share_Family";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
    "/mnt/Share_Friends" = {
      device = "//${remote}/Share_Friends";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
    "/mnt/Personal_Kent" = {
      device = "//${remote}/Personal_Kent";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        uid = "1000";
        gid = "100";
        file_mode = "0777";
        dir_mode = "0777";
      in ["${automount_opts},credentials=/etc/smbcredentials,file_mode=${file_mode},dir_mode=${dir_mode}"];
    };
  };

  environment.systemPackages = with pkgs; [
    # Allows me to mount samba drives
    cifs-utils
  ];

  # For helping find local samba shares.
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
}
