{ ... }:
{

  # Syncthing service
  services.syncthing = {
    enable = true;
    key = "/run/secrets/greatblue-syncthing-key-pem";
    cert = "/run/secrets/greatblue-syncthing-cert-pem";
    user = "kent";
    settings = {
      # setting.devices can be found in modules/common/syncthing.nix
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
          path = "/home/kent/Backups/Android/";
          devices = [ "Delaware" ];
        };
        "Kent_Backup_PC" = {
          path = "/home/kent/Backups/PC";
          devices = [ "Delaware" ];
        };
        "Kent_School" = {
          path = "/home/kent/School";
          devices = [ "Delaware" "Kent_y700" ];
        };
      };
    };
  };

  sops.secrets = let
    opts = {
      sopsFile = ./syncthing.yaml;
      mode     = "0400";
      owner    = "kent";
      group    = "users";
    };
  in
  {
    greatblue-syncthing-key-pem = opts;
    greatblue-syncthing-cert-pem = opts;
  };
}
