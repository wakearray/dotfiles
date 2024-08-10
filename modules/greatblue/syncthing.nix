{ inputs,
  outputs,
  lib,
  config,
  pkgs, ... }:
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
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      devices = {
        "Delaware" = {
          id = "NPGSSWY-NXG6AOK-2D56VX6-DEZTGFD-OZFWLNX-NMZWCYG-VT6Q4X4-OCIWPQM";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "Family_Notes" = {         # Name of folder in Syncthing, also the folder ID
          path = "/home/kent/notes/family/";    # Which folder to add to Syncthing
          devices = [ "Delaware" ];
        };
        "Kent_Notes" = {
          path = "/home/kent/notes/personal/";
          devices = [ "Delaware" ];
        };
      };
    };
  };
}
