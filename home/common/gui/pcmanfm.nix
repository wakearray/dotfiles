{ lib, config, pkgs, ... }:
let
  pcman = config.gui.pcmanfm;
in
{
  options.gui.pcmanfm = with lib; {
    enable = mkEnableOption "Enable an opionated file manager config using pcmanfm";
  };

  config = lib.mkIf pcman.enable {
    home.packages = with pkgs; [
      pcmanfm

      # Add lxmenu-data to be offered a list of "Installed applications" when opening a file.
      lxmenu-data

      # Add shared-mime-info to recognise different file types.
      shared-mime-info

      # Archive manager
      file-roller
    ];
  };
}
