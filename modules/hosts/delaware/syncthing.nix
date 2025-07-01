{ ... }:
{
  # Syncthing, a file syncing service
  services.syncthing = {
    enable     = true;
    key        = "/run/secrets/delaware-syncthing-key-pem";
    cert       = "/run/secrets/delaware-syncthing-cert-pem";
    user       = "syncthing";
    group      = "userdata";
    guiAddress = "0.0.0.0:8384";
    settings = {
      # setting.devices can be found in modules/common/syncthing.nix
      folders = {
        "Family_Notes" = {         # Name of folder in Syncthing, also the folder ID
          path = "/data/userdata/Family/Notes";    # Which folder to add to Syncthing
          devices = [
            "Jess_S20_Ultra"
	          "Jess_Cichlid"
            "Jess_Boox"

            "Kent_S24_Ultra"
            "Kent_P80"
            "Kent_y700"
            "Kent_Boox"
            "Kent_Hisense_A9"
            "Kent_Hibreak_Color"
            "Kent_GreatBlue"
            "Kent_Starling"
          ];
        };
        "Kent_Notes" = {
          path = "/data/userdata/Kent/Notes";
          devices = [
            "Kent_S24_Ultra"
            "Kent_P80"
            "Kent_y700"
            "Kent_Boox"
            "Kent_Hisense_A9"
            "Kent_Hibreak_Color"
            "Kent_GreatBlue"
            "Kent_Starling"
          ];
        };
        "Kent_S24_Ultra" = {
          path = "/data/userdata/Kent/Pictures/S24_Ultra";
          devices = [ "Kent_S24_Ultra" ];
        };
	      "Kent_Backup_Android" = {
          path = "/data/userdata/Kent/Backups/Android";
	        devices = [
            "Kent_S24_Ultra"
            "Kent_P80"
            "Kent_y700"
            "Kent_Boox"
            "Kent_Hisense_A9"
            "Kent_Hibreak_Color"
            "Kent_GreatBlue"
            "Kent_Starling"
          ];
	      };
        "Kent_Backup_PC" = {
          path = "/data/userdata/Kent/Backups/PC";
	        devices = [
            "Kent_GreatBlue"
            "Kent_Starling"
          ];
	      };

	      "Jess_Backup_Android" = {
          path = "/data/userdata/Jess/Backups/Android";
	        devices = [
            "Jess_S20_Ultra"
	          "Jess_Cichlid"
            "Jess_Shoebill"
            "Jess_Boox"
          ];
	      };
        "Jess_Backup_PC" = {
          path = "/data/userdata/Jess/Backups/PC";
	        devices = [
            "Jess_Cichlid"
            "Jess_Shoebill"
          ];
	      };
        "Jess_Notes" = {
          path = "/data/userdata/Jess/Notes";
          devices = [
	          "Jess_S20_Ultra"
	          "Jess_Cichlid"
            "Jess_Shoebill"
            "Jess_Boox"
	        ];
        };
        "Jess_S20_Ultra" = {
          path = "/data/userdata/Jess/Pictures/S20_Ultra";
          devices = [ "Jess_S20_Ultra" ];
        };
      };
    };
  };

  sops.secrets = let
    opts = {
      sopsFile = ./syncthing.yaml;
      mode     = "0400";
      owner    = "syncthing";
      group    = "syncthing";
    };
  in
  {
    delaware-syncthing-key-pem = opts;
    delaware-syncthing-cert-pem = opts;
  };

  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
