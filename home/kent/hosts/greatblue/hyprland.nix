{ config, pkgs, system-details, ... }:
let
  hostname = system-details.host-name;
in
{
  config = {
    home.wm.hyprland = {
      enable = true;
      modKey = "SUPER";
      settings = {
        # https://wiki.hyprland.org/Configuring/Monitors/
        monitors = [
          # Built in display: eDP-1
          "desc:Japan Display Inc. GPD1001H 0x00000001, 2560x1600@60.01Hz, 0x0, 1.666667"
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
        windowRules = [
          "workspace 2, class:^(discord)(.*)"
          "workspace 2, class:^(signal)(.*)"
          "workspace 2, class:^(element)(.*)"
          "workspace 2, class:^(telegram)(.*)"
          "workspace 3, title:^(.*)( - YouTube — Mozilla Firefox)$"
          "workspace 4, class:^(firefox)(.*)"
          "workspace 8, class:^(1Password)(.*)"
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
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id primary   --screen 0 --arg width=\"118%\" --arg offset=\"0\""
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id secondary --screen 1 --arg width=\"99%\" --arg offset=\"9\""
          "${pkgs.bash}/bin/bash ${config.xdg.configHome}/eww/scripts/battery.sh > /dev/null 2>&1 &"
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

          # Disable built in-monitor when closing the lid
          #", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
          # Re-enable built-in monitor when opening the lid
          #", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 2560x1600, 0x0, 1.67\""

          # Disable built in-monitor when closing the lid
          ", switch:on:Lid Switch, exec, export ${hostname}_LID=\"closed\""
          # Re-enable built-in monitor when opening the lid
          ", switch:off:Lid Switch, exec, export ${hostname}_LID=\"open\""

        ];
      };
    };
    # I should automate this making anything listed as Android or laptop enable.
    # Enables battery life display on eww
    gui.eww = {
      battery.enable = true;
    };
  };
}
