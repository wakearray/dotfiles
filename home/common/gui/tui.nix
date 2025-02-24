{ lib, config, pkgs, ... }:
let
  gui = config.gui;
in
{
  config = lib.mkIf gui.enable {
    home.packages = with pkgs; [
      # tui for controlling wifi
      impala
      # tui for managing LLMs
      tenere
    ];
  };
}
