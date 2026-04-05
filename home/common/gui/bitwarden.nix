{ lib, config, pkgs, ... }:
let
  cfg = config.gui.bitwarden;
in
{
  options.gui.bitwarden = with lib; {
    enable = mkEnableOption "Enable Bitwarden.";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
      keyguard
    ];
  };
}
