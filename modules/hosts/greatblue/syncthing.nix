{ ... }:
let
  secrets = "/etc/nixos/secrets";
in
{
  # Syncthing, a file syncing service
  services.syncthing = {
    enable = true;
    key = "${secrets}/syncthing/key.pem";
    cert = "${secrets}/syncthing/cert.pem";
    user = "kent";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "Delaware" = {
          id = "NPGSSWY-NXG6AOK-2D56VX6-DEZTGFD-OZFWLNX-NMZWCYG-VT6Q4X4-OCIWPQM";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "Family_Notes" = {
          path = "/home/kent/notes/family/";
          devices = [ "Delaware" ];
        };
        "Kent_Notes" = {
          path = "/home/kent/notes/personal/";
          devices = [ "Delaware" ];
        };
        "Kent_Backup_Android" = {
          path = "/home/kent/Kent_Backup_Android";
          devices = [ "Delaware" ];
        };
        "Kent_Backup_PC" = {
          path = "/home/kent/Kent_Backup_PC";
          devices = [ "Delaware" ];
        };
      };
    };
  };
}
