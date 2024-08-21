{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
let

in
{
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

  # Syncthing, a file syncing service
  services.syncthing = {
    enable = true;
    key = "${config.secrets}/syncthing/key.pem";
    cert = "${config.secrets}/syncthing/cert.pem";
    user = "nextcloud";
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "Kent_S24_Ultra" = { id = "SD6ZVE2-JPJEKJM-I2VHZBK-A42GUPM-EGIZIG7-QKI3H5B-KG3XEPL-MDETKQZ"; };
        "Kent_P80" = { id = "TUOYN7I-JW7FVCY-B2RJSIW-2QJD6KO-7MQ5JOY-QK5X6HA-BKSZ4KL-FGSVDQL"; };
        "Kent_y700" = { id = "QA7LAZ2-36XZMTG-IQ6IKMK-C3RKD5O-Y5X53TV-J5NLKQM-NPOG6RU-TP7WTQE"; };
        "Kent_Boox" = { id = "T3U4VSV-7LPWYBK-7GNDAMU-GG7IMXO-OKCFZQB-4WMC2KP-RFANMLH-FFO3WQ7"; };
        "Kent_Hisense_A9" = { id = "S55WSYJ-K3C6MV7-YWEUAW5-YAYHAB2-FIZ7RNR-NE7KCTZ-PZNPO2I-6S3W4AT"; };
        "Kent_GreatBlue" = {
          id = "6B6CFWQ-AOVKOLS-AJ77Y7U-T5G7QPG-IQTPCSJ-NRPZNJR-4LMLIRS-FGMYSQ2";
          autoAcceptFolders = true;
        };
        "Jess_S20_Ultra" = { id = "F436IQN-OOP5KEX-CNCY7VA-4CKUSOR-6YUHIO2-TTESNNW-TMMSMNI-CQZNUAZ"; };
      };
      folders = {
        "Family_Notes" = {         # Name of folder in Syncthing, also the folder ID
          path = "/mnt/syncthing/shared_family/notes";    # Which folder to add to Syncthing
          devices = [
            "Jess_S20_Ultra"
            "Kent_S24_Ultra"
            "Kent_P80"
            "Kent_y700"
            "Kent_Boox"
            "Kent_Hisense_A9"
            "Kent_GreatBlue"
          ];
        };
        "Kent_Notes" = {
          path = "/mnt/syncthing/kent_personal/notes";
          devices = [
            "Kent_S24_Ultra"
            "Kent_P80"
            "Kent_y700"
            "Kent_Boox"
            "Kent_Hisense_A9"
            "Kent_GreatBlue"
          ];
        };
        "Kent_DCIM" = {
          path = "/mnt/syncthing/kent_personal/DCIM";
          devices = [ "Kent_S24_Ultra" ];
        };
	"Kent_Backup_Android" = {
          path = "/mnt/syncthing/kent_personal/Backups/Android";
	  devices = [
            "Kent_S24_Ultra"
            "Kent_P80"
            "Kent_y700"
            "Kent_Boox"
            "Kent_Hisense_A9"
            "Kent_GreatBlue"
          ];
	};
	"Kent_Backup_PC" = {
          path = "/mnt/syncthing/kent_personal/Backups/PC";
	  devices = [ "Kent_GreatBlue" ];
	};
        "Jess_Notes" = {
          path = "/mnt/syncthing/jess_personal/notes";
          devices = [ "Jess_S20_Ultra" ];
        };
        "Jess_DCIM" = {
          path = "/mnt/syncthing/jess_personal/DCIM";
          devices = [ "Jess_S20_Ultra" ];
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
