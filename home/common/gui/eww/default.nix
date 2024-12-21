{ lib, config, pkgs, ... }:
let
  cfg = config.gui.eww;
in
{
  imports = [
    ./bar
  ];
  options.gui.eww = with lib; {
    enable = mkEnableOption "Enable eww";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      playerctl
      eww
    ];
  };
}
