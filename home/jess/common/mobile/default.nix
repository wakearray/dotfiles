{ lib, system-details, ... }:
{
  # home/jess/common/mobile/
  imports = [];
  config = lib.mkIf (builtins.match "android" system-details.host-type != null) {
    programs = {};
  };
}
