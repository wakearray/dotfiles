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
    user = "jess";
    # overrides any devices added or deleted through the WebUI
    overrideDevices = true;
    # overrides any folders added or deleted through the WebUI
    overrideFolders = true;
    settings = {
      devices = {
        "Delaware" = {
          id = "NPGSSWY-NXG6AOK-2D56VX6-DEZTGFD-OZFWLNX-NMZWCYG-VT6Q4X4-OCIWPQM";
          autoAcceptFolders = true;
        };
      };
      folders = {
        # Name of folder in Syncthing, also the folder ID
        "Family_Notes" = {
	  # Which folder to add to Syncthing
          path = "/home/jess/notes/family/";
          devices = [ "Delaware" ];
        };
        "Jess_Notes" = {
          path = "/home/jess/notes/personal/";
          devices = [ "Delaware" ];
        };
      };
    };
  };
}
