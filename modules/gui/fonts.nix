{ pkgs,
  lib,
  config,
  ... }:
{
  config = lib.mkIf config.gui.enable {
    fonts.packages = with pkgs; [
      # Better emojis
      twemoji-color-font

      # Nerdfonts
      unstable.nerdfonts
    ];
  };
}