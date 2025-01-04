{ config, pkgs, ... }:
let
  cfg = config.home.wm.hyprland;
in
{
  config = {
    home.wm.hyprland = {
      enable = true;
      modKey = "SUPER";
      settings = {
        "$mod" = "${cfg.modKey}";
        # https://wiki.hyprland.org/Configuring/Monitors/
        monitor = [
          "desc:Japan Display Inc. GPD1001H 0x00000001, 2560x1600@60.01Hz, auto-down, 1.666667"
          "desc:AOC 2279WH AHXJ49A007682, 1920x1080@60.00Hz, auto-up, 1"
          ", preferred, auto, 1"
        ];
        windowrulev2 = [
          "workspace 2, class:^(Discord)(.*)"
          "workspace 2, class:^(Signal)(.*)"
          "workspace 2, class:^(Element)(.*)"
          "workspace 2, class:^(Telegram)(.*)"
          "workspace 4, class:^(Firefox)(.*)"
          "workspace 8, class:^(1Password)(.*)"
        ];
        plugin = {
          hyprsplit = {
            num_workspaces = 9;
          };
          # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprbars
          hyprbars = {
            # example config
            bar_height = 20;

            # example buttons (R -> L)
            # hyprbars-button = color, size, on-click
            hyprbars-button = [
              "rgb(ff4040), 10, 󰖭, hyprctl dispatch killactive"
              "rgb(eeee11), 10, , hyprctl dispatch fullscreen 1"
            ];
          };
        };
        general = {
          gaps_out = 6;
          resize_on_border = true;
          layout = "master";
          snap = {
            enabled = true;
          };
        };
        decoration = {
          shadow = {
            enabled = false;
          };
          rounding = 10;
          blur = {
            enabled = false;
          };
        };
        input = {
          numlock_by_default = true;
          touchpad = {
            natural_scroll = true;
          };
        };
        gestures = {
          workspace_swipe = true;
        };
        misc = {
          font_family = "Mono";
        };
        binds = {
          workspace_back_and_forth = true;
        };
        exec-once = [
          "alacritty"
          "firefox"
          "signal-desktop"
          "${pkgs.eww}/bin/eww daemon"
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar"
        ];
        exec-shutdown = [
          "${pkgs.eww}/bin/eww close-all && pkill eww"
        ];
        # Key bindings
        # https://wiki.hyprland.org/Configuring/Binds/
        bind = [
          # App launcher shortcut
          "$mod      , D       , exec, rofi -show drun"
          # Open Alacritty on workspace 1
          "$mod      , A       , exec, alacritty"
          # Open Firefox on active workspace
          "$mod      , B       , exec, firefox"
          # Take a screenshot
          "          , Print   , exec, grimblast copy area"

          # Send active window to scratchpad
          "$mod      , S       , exec, scratchpad"
          # Send active window to scratchpad
          "$mod SHIFT, S       , exec, scratchpad -g"

          # Swap the workspaces onactive monitor with the monitor to it's right
          "$mod SHIFT, D       , split:swapactiveworkspaces, current +1"
          # Finds all windows that are in invalid workspaces and moves them
          # to the current workspace. Useful when unplugging monitors.
          "$mod SHIFT, G       , split:grabroguewindows"
          # Close the active app
          "$mod      , Q       , killactive"
          # Toggle floating on the currently active app
          "$mod      , T       , togglefloating"
          # Toggle grouping on the currently active app
          "$mod      , G       , togglegroup"
          # Switch which window in active group is visible b = backwards
          # code:59 = ,
          "$mod      , code:59 , changegroupactive, b"
          # Switch which window in active group is visible f = forwards
          # code:60 = .
          # Use `wev` to find the key code for additional keys
          "$mod      , code:60 , changegroupactive, f"
          # Toggle fullscreen on the currently active app
          "$mod      , F       , fullscreen"
          # Toggle pinning the active floating app to the monitor rather than workspace
          "$mod      , P       , pin"
          # Lock the computer
          "$mod      , L       , exec, hyprlock --immediate"

          # Exits hyperland
          "$mod SHIFT, Q       , exec, uwsm stop"

          # Move the window focus with arrow keys
          "$mod      , left    , movefocus , l"
          "$mod      , right   , movefocus , r"
          "$mod      , up      , movefocus , u"
          "$mod      , down    , movefocus , d"
          # Move the active window around the workspace with the arrow keys
          "$mod SHIFT, left    , movewindow, l"
          "$mod SHIFT, right   , movewindow, r"
          "$mod SHIFT, up      , movewindow, u"
          "$mod SHIFT, down    , movewindow, d"
        ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, split:workspace, ${toString ws}"
            "$mod, code:1${toString i}, exec, eww update -c ${config.xdg.configHome}/eww/bar active_workspace='${toString ws}'"
            "$mod SHIFT, code:1${toString i}, split:movetoworkspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, exec, eww update -c ${config.xdg.configHome}/eww/bar active_workspace='${toString ws}'"
          ])9)
        );
        # Flags:
        # m -> mouse, see below.
        # https://wiki.hyprland.org/Configuring/Binds/#mouse-binds
        bindm = [
          # Grab and move floating windows with mod + left mouse button
          "$mod      , mouse:272, movewindow"

          # Resize and maintain aspect ratio of floating windows using mod + right
          "$mod      , mouse:273, resizewindow 1"

          # Resize floating windows using mod + shift + right
          "$mod SHIFT, mouse:273, resizewindow"
        ];
        # Flags:
        # e -> repeat, will repeat when held.
        # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
        bindel = [
          # Map the volume up/down keys on keyboards to increase/decrease volume by 5% using pamixer
          ", XF86AudioRaiseVolume, exec, pamixer -i 5"
          ", XF86AudioRaiseVolume, exec, eww update -c ${config.xdg.configHome}/eww/bar volume='\$(pamixer --get-volume)'"
          ", XF86AudioLowerVolume, exec, pamixer -d 5"
          ", XF86AudioLowerVolume, exec, eww update -c ${config.xdg.configHome}/eww/bar volume='\$(pamixer --get-volume)'"
        ];
        # Flags:
        # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
        bindl = [
          # Bind mute key to toggle mute
          ", XF86AudioMute, exec, pamixer -t"
          # Also have it update an eww variable
          ", XF86AudioMute, exec, eww update -c ${config.xdg.configHome}/eww/bar mute_status='\$(pamixer --get-mute)'"

          # Bind play/pause key to play-pause functionality
          ", XF86AudioPlay, exec, playerctl play-pause"

          # Bind previous key to previous functionality
          ", XF86AudioPrev, exec, playerctl previous"
          #  Bind previous key to previous functionality
          ", XF86AudioNext, exec, playerctl next"
        ];
      };
    };
    gui.eww = {
      enable = true;
      bar.enable = true;
    };
  };
}
