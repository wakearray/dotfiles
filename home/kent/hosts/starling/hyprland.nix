{ config, pkgs, ... }:
{
  config = {
    home.wm.hyprland = {
      enable = true;
      modKey = "SUPER";
      settings = {
        # https://wiki.hyprland.org/Configuring/Monitors/
        monitors = [
          # Built in display: DSI-1
          "DSI-1,preferred,auto,1,transform,3"
          # External USB-C display with VESA
          "desc:Stargate Technology F156P1 0x00001111, 1920x1080@60.00Hz, auto-up, 1"
          # External USB-C display without VESA, labeled "QQH"
          "desc:DZX Z1-9 0000000000000, preferred, auto-up, 1"
          # Mirror main display on QQH
          # "DP-1, preferred, auto, 1, mirror,desc:Japan Display Inc. GPD1001H 0x00000001"
          # Primary monitor on the 4 display dock
          "desc:AOC 2279WH AHXJ49A007682, 1920x1080@60, auto-up, 1"
          # Literally any other monitor
          ", preferred, auto, 1"
        ];
        input = {
          # <bool> Engage numlock by default.
          numlock_by_default = true;
          touchdevice = {
            # Rotate the touch screen to match the screen rotation.
            transform = "3";
          };
        };
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
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_0 --screen 0 --arg width=\"100%\" --arg height=\"2%\" --arg offset=\"0\""
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_1 --screen 1 --arg width=\"100%\" --arg height=\"2%\" --arg offset=\"9\""
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_2 --screen 2 --arg width=\"100%\" --arg height=\"2%\" --arg offset=\"18\""
          "${pkgs.bash}/bin/bash ${config.xdg.configHome}/eww/scripts/battery.sh  > /dev/null 2>&1 &"
          "${pkgs.bash}/bin/bash ${config.xdg.configHome}/eww/scripts/hyprland.sh > /dev/null 2>&1 &"
        ];
        exec = [ ];
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
}
