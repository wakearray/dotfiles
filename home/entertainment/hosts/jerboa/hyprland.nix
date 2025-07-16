{ config, pkgs, ... }:
{
  config = {
    home = {
      wm.hyprland = {
        enable = true;
        modKey = "SUPER";
        settings = {
          # https://wiki.hyprland.org/Configuring/Monitors/
          monitors = [
            # Literally any other monitor
            ", preferred, auto, 4.0"
          ];
          windowRules = [
            "group set, class:(firefox), title:^(.*)!(Mozilla Firefox Private Browsing)$"
            "float, class:(firefox), title:(Picture-in-Picture)"
            "pin, class:(firefox), title:(Picture-in-Picture), floating:1"
            "size 20% 20%, class:(firefox), title:(Picture-in-Picture), floating:1, pinned:1"
            "workspace 2, class:(Alacritty)"
          ];
          animations = {
            enable = true;
            firstLaunchAnimation = true;
          };
          execOnce = [
            "alacritty"
            "firefox"
            "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_0 --screen 0 --arg width=\"100%\" --arg height=\"2%\" --arg offset=\"0\""
          ];
          exec = [
            "${pkgs.bash}/bin/bash ${config.xdg.configHome}/eww/scripts/hyprland.sh > /dev/null 2>&1 &"
          ];
          execShutdown = [
            "${pkgs.eww}/bin/eww close-all && pkill eww"
          ];
          bindl = [
            # Bind mute key to toggle mute
            ", XF86AudioMute, exec, pamixer -t"
            # Also have it update an eww variable
            ", XF86AudioMute, exec, eww update -c ${config.xdg.configHome}/eww/bar mute_status='\$(pamixer --get-mute)'"

            # Bind play/pause key to play-pause functionality
            ", XF86AudioPlay, exec, playerctl play-pause"

            # Bind previous key to previous functionality
            ", XF86AudioPrev, exec, playerctl previous"
            # Bind previous key to previous functionality
            ", XF86AudioNext, exec, playerctl next"
          ];
        };
      };
    };
  };
}
