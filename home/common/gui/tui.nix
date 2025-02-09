{ lib, config, pkgs, ... }:
{
  config = lib.mkIf config.gui.enable {
    home.packages = with pkgs; [
      # tui for controlling wifi
      impala
      # tui for managing LLMs
      tenere
    ];
  };
}
