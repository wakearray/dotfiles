{ pkgs, lib, config, ... }:
let
  gui = config.gui;
  office = gui.office;
in
{
  options.gui.office = with lib; {
    enable = mkEnableOption "Turn on office software.";
  };
  config = lib.mkIf (gui.enable && office.enable) {
    environment.systemPackages = with pkgs; [
      libreoffice-qt6-fresh

      # Spell check for libreoffice
      hunspell
      hunspellDicts.en_US
    ];
  };
}
