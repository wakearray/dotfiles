{ pkgs, lib, config, ... }:
let
  cfg = config.gui.office;
in
{
  options.gui.office = with lib; {
    enable = mkEnableOption "Turn on office software.";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      stable.libreoffice-qt6-fresh

      # Spell check for libreoffice
      stable.hunspell
      stable.hunspellDicts.en_US
    ];
  };
}
