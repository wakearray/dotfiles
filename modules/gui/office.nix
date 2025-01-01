{ pkgs, lib, config, ... }:
let
  cfg = config.gui;
in
{
  options.gui.office = with lib; {
    enable = mkEnableOption "Turn on office software.";
  };
  config = lib.mkIf (cfg.enable && cfg.office.enable) {
    environment.systemPackages = with pkgs; [
      libreoffice-qt6-fresh

      # Spell check for libreoffice
      hunspell
      hunspellDicts.en_US
    ];
  };
}
