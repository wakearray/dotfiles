{ config, pkgs, ... }:
{
  config = {
    gui.wayland.enable = true;
    home.wm.hyprland = {
      enable = true;
      modKey = "SUPER";
      settings = {
        windowRules = [
          "group set, class:firefox, title:^(.*)!(Mozilla Firefox Private Browsing)$"
          "float, class:(firefox), title:(Picture-in-Picture)"
          "pin, class:(firefox), title:(Picture-in-Picture), floating:1"
          "size 20% 20%, class:(firefox), title:(Picture-in-Picture), floating:1, pinned:1"
        ];
        animations = {
          enable = true;
          firstLaunchAnimation = true;
        };
        execOnce = [
          "alacritty"
          "firefox"
          "signal-desktop"
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar daemon"
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_0 --screen 0 --arg width=\"120%\" --arg offset=\"0\""
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_1 --screen 1 --arg width=\"100%\" --arg offset=\"9\""
        ];
        exec = [
          "${pkgs.bash}/bin/bash ${config.xdg.configHome}/eww/scripts/battery.sh  > /dev/null 2>&1 &"
          "${pkgs.bash}/bin/bash ${config.xdg.configHome}/eww/scripts/hyprland.sh > /dev/null 2>&1 &"
        ];
        execShutdown = [
          "${pkgs.eww}/bin/eww close-all && pkill eww"
        ];
      };
    };
  };
}
