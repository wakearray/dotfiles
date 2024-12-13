{ lib, ... }:
{
  imports = [
    ./bar
  ];
  options.gui.eww = with lib; {
    enable = mkEnableOption "Enable eww";
  };
}
