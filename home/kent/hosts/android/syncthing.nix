{ config, ... }:
{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        "Delaware" = {
          id = "NPGSSWY-NXG6AOK-2D56VX6-DEZTGFD-OZFWLNX-NMZWCYG-VT6Q4X4-OCIWPQM";
          autoAcceptFolders = true;
        };
      };
      folders = {
        "Family_Notes" = {
          path = "${config.home.homeDirectory}/notes/family/";
          devices = [ "Delaware" ];
        };
        "Kent_Notes" = {
          path = "${config.home.homeDirectory}/notes/personal/";
          devices = [ "Delaware" ];
        };
      };
    };
  };
}
