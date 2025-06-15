{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  i3 = gui.wm.i3;
  launcher = i3.launcher;
  isAndroid = config.home.systemDetails.isAndroid;
in
{
  options.gui.wm.i3.launcher = with lib; {
    enable = mkOption {
      type = types.bool;
      default = (gui.enable && (i3.enable && isAndroid));
      description = "A helper script to launch i3 on Android. This is only needed on Android.";
    };
  };

  config = lib.mkIf launcher.enable {
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
