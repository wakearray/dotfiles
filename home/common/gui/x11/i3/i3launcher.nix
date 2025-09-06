{ lib, config, pkgs, ... }:
let
  cfg = config.gui.wm.i3.launcher;
in
{
  options.gui.wm.i3.launcher = with lib; {
    enable = mkEnableOption "A helper script to launch i3 on Android. This is only needed on Android." // { default = config.home.systemDetails.isAndroid; };
  };

  config = lib.mkIf cfg.enable {
    home.file.".local/bin/i3launcher" = {
      enable = true;
      force = true;
      executable = true;
      text = /*bash*/ ''
#!/usr/bin/env bash

export DISPLAY=:0
export PULSE_SERVER=tcp:127.0.0.1:4713
export XDG_RUNTIME_DIR=/tmp

${pkgs.dbus}/bin/dbus-launch --exit-with-session ${config.xsession.windowManager.i3.package}/bin/i3
      '';
    };
  };
}
