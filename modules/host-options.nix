{ lib, ... }:
{
  options.host-options = {
    display-system = lib.mkOption {
      type = lib.types.enum [ "wayland" "x11" "null" ];
      default = "null";
      description = "Select which display system this host is using. Will determine some predefined options shared between devices using this display system.";
    };
    host-type = lib.mkOption {
      type = lib.types.enum [ "laptop" "desktop" "server" "android" "null" ];
      default = "null";
      description = "Select which type of device this is. Will determine some predefined options and programs shared between devices of this type.";
    };
  };
}
