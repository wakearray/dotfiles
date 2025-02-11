{ lib, config, pkgs, ... }:
let
  cfg = config.android.gui.wayland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprland
    ];
    home.file.".local/bin/launch_hyperland" = {
      enable = true;
      force = true;
      executable = true;
      text = /*bash*/ ''
#!/usr/bin/env bash

${pkgs.hyprland}/bin/hyprland
      '';
    };
  };
}
