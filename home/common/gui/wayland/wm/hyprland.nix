{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.home.wm.hyprland;
  s = cfg.settings;
in
{
  options.home.wm.hyprland = with lib; {
    enable = mkEnableOption "Enable an opinionated hyperland home-manager configuration.";

    modKey = mkOption {
      type = types.enum [ "SHIFT" "CAPS" "CTRL" "ALT" "SUPER" ];
      default = "SUPER";
    };

    colors = {
      general = {
        inactiveBorder = mkOption {
          type = types.str;
          default = "0xff444444";
          description = "Color of the border for inactive windows. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
        activeBorder = mkOption {
          type = types.str;
          default = "0xffffffff";
          description = "Color of the border for active windows. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
        noGroupBorder = mkOption {
          type = types.str;
          default = "0xffffaaff";
          description = "Inactive border color for window that cannot be added to a group. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
        noGroupAorderActive = mkOption {
          type = types.str;
          default = "0xffff00ff";
          description = "Active border color for window that cannot be added to a group. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
      };
    };

    settings = {
      monitors = mkOption {
        type = types.listOf types.str;
        default = [", preferred, auto, 1"];
        description = "A list of expected monitors as described here: https://wiki.hyprland.org/Configuring/Monitors/ The default will accept any recognized monitors and use them under their preferred default preferences.";
      };
      windowRules = mkOption {
        type = types.listOf types.str;
        default = [", preferred, auto, 1"];
        description = "A list of window rules (v2 only) as described here: https://wiki.hyprland.org/Configuring/Window-Rules/#window-rules-v2";
      };
      animations = {
        enable = mkEnableOption "Enable animations.";
        firstLaunchAnimation = mkEnableOption "Enable animation for opening apps.";
      };
      input = mkOption {
        type = types.attrs;
        default = {
          # <bool> Engage numlock by default.
          numlock_by_default = true;
          touchpad = {
            # <bool> Inverts scrolling direction. When enabled,
            # scrolling moves content directly, rather than
            # manipulating a scrollbar.
            natural_scroll = true;
          };
        };
        description = "Input config as defined here: https://wiki.hyprland.org/Configuring/Variables/#input";
      };
      execOnce = mkOption {
        type = types.listOf types.str;
        default = [
          "alacritty"
          "firefox"
          "signal-desktop"
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar daemon"
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_0   --screen 0 --arg width=\"100%\" --arg offset=\"0\""
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_1 --screen 1 --arg width=\"100%\" --arg offset=\"9\""
        ];
        description = "A list of command line arguments you want run when hyprland starts.";
      };
      exec = mkOption {
        type = types.listOf types.str;
        default = [
          "${pkgs.bash}/bin/bash ${config.xdg.configHome}/eww/scripts/hyprland.sh > /dev/null 2>&1 &"
        ];
        description = "A list of command line arguments you want run when hyprland starts.";
      };
      execShutdown = mkOption {
        type = types.listOf types.str;
        default = [
          "${pkgs.eww}/bin/eww close-all && pkill eww"
        ];
        description = "A list of command line arguments you want run when hyprland exits.";
      };
      bind = mkOption {
        type = types.listOf types.str;
        default = [
          # App launcher shortcut
          "$mod      , D       , exec, rofi -show drun"
          # Rofi move window to current workspace
          "$mod SHIFT, D       , exec, rofi -show hyprland-clients -modi \"hyprland-clients:rofihyprlandclients\""
          # Open Alacritty on workspace 1
          "$mod      , A       , exec, alacritty"
          # Open Firefox on active workspace
          "$mod      , B       , exec, firefox"
          # Move workspaces from monitor 0 to monitor 1
          "$mod      , M       , exec, monitorswitch 0 1"
          # Move workspaces from monitor 1 to monitor 0
          "$mod SHIFT, M       , exec, monitorswitch 1 0"
          # Take a screenshot
          "          , Print   , exec, grimblast copy area"

          # Send active window to scratchpad
          "$mod      , S       , exec, scratchpad"
          # Send active window to scratchpad
          "$mod SHIFT, S       , exec, scratchpad -g"

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
          # Lock and suspend the computer
          "$mod      , L       , exec, systemctl suspend && hyprlock --immediate"

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
            "$mod SHIFT, code:1${toString i}, split:movetoworkspace, ${toString ws}"
          ])9)
        );
        description = "Key bindings as described here: https://wiki.hyprland.org/Configuring/Binds/ use $mod to reference your assigned mod key.";
      };
      bindm = mkOption {
        type = types.listOf types.str;
        default = [
          # Grab and move floating windows with mod + left mouse button
          "$mod      , mouse:272, movewindow"

          # Resize and maintain aspect ratio of floating windows using mod + right
          "$mod      , mouse:273, resizewindow 1"

          # Resize floating windows using mod + shift + right
          "$mod SHIFT, mouse:273, resizewindow"
        ];
        description = "Mouse key bindings as described here: https://wiki.hyprland.org/Configuring/Binds/#mouse-binds use $mod to reference your assigned mod key.";
      };
      bindl = mkOption {
        type = types.listOf types.str;
        default = [
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
        description = "Key bindings that will work on your lockscreen as described here: https://wiki.hyprland.org/Configuring/Binds/ use $mod to reference your assigned mod key.";
      };
      bindel = mkOption {
        type = types.listOf types.str;
        default = [
          # Map the volume up/down keys on keyboards to increase/decrease volume by 5% using pamixer
          ", XF86AudioRaiseVolume, exec, pamixer -i 5"
          ", XF86AudioRaiseVolume, exec, eww update -c ${config.xdg.configHome}/eww/bar volume='\$(pamixer --get-volume)'"
          ", XF86AudioLowerVolume, exec, pamixer -d 5"
          ", XF86AudioLowerVolume, exec, eww update -c ${config.xdg.configHome}/eww/bar volume='\$(pamixer --get-volume)'"
        ];
        description = "Key bindings that will repeat when held and work on the lock screen as described here: https://wiki.hyprland.org/Configuring/Binds/ use $mod to reference your assigned mod key.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # Disabled due to using UWSM
      # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
      systemd.enable = false;
      settings = {
        "$mod" = "${cfg.modKey}";
        # https://wiki.hyprland.org/Configuring/Monitors/
        monitor = s.monitors;
        windowrulev2 = s.windowRules;
        plugin = {
          hyprsplit = {
            num_workspaces = 9;
            persistent_workspaces = true;
          };
        };
        general = {
          # <int>  Window border in pixels
          border_size = 1;
          # <bool> false = show a border on floating windows
          no_border_on_floating = false;
          # <int>  Gaps between windows in pixels
          gaps_in = 5;
          # <int>  Gaps around screen edge/eww bar
          gaps_out = 12;
          # <int>  Gaps between workspaces (not sure what this means since workspaces are displayed 1 at a time)
          gaps_workspaces = 0;
          # border color for inactive windows
          "col.inactive_border" = cfg.colors.general.inactiveBorder;
          # border color for the active window
          "col.active_border" = cfg.colors.general.activeBorder;
          # inactive border color for window that cannot be added to a group
          "col.nogroup_border" = cfg.colors.general.noGroupBorder;
          # active border color for window that cannot be added to a group
          "col.nogroup_border_active" = cfg.colors.general.noGroupAorderActive;
          # <enum> of "master", "dwindle"
          # Sets the order and position of how new windows spawn into a workspace
          layout = "master";
          # <bool> if true, will not fall back to the next available window when
          # moving focus in a direction where no window was found
          no_focus_fallback = false;
          # <bool> enables resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true;
          # <int>  extends the area around the border where you can click and drag on,
          # only used when general:resize_on_border is on.
          extend_border_grab_area = 15;
          # <bool> show a cursor icon when hovering over borders, only used when
          # general:resize_on_border is on.
          hover_icon_on_border = true;
          # <bool> master switch for allowing tearing to occur.
          allow_tearing = false;
          # <int>  force floating windows to use a specific corner when being
          # resized (1-4 going clockwise from top left, 0 to disable)
          resize_corner = 0;
          # Controls floating window snapping
          snap = {
            # <bool> enable snapping for floating windows
            enabled = true;
            # <int>  minimum gap in pixels between windows before snapping
            window_gap = 10;
            # <int>  minimum gap in pixels between window and monitor edges
            # before snapping
            monitor_gap = 10;
            # <bool> if true, windows snap such that only one border’s worth
            # of space is between them
            border_overlap = false;
          };
        };
        decoration = {
          # <int> rounded corners’ radius (in layout px)
          rounding = 10;
          # <float> adjusts the curve used for rounding corners,
          # larger is smoother, 2.0 is a circle, 4.0 is a squircle.
          # [2.0 - 10.0]
          # rounding_power = 2.0;
          # <float> opacity of active windows. [0.0 - 1.0]
          active_opacity = 1.0;
          # <float> opacity of inactive windows. [0.0 - 1.0]
          inactive_opacity = 1.0;
          # <float> opacity of fullscreen windows. [0.0 - 1.0]
          fullscreen_opacity = 1.0;
          # <bool> enables dimming of inactive windows
          dim_inactive = false;
          # <float> how much inactive windows should be dimmed [0.0 - 1.0]
          dim_strength = 0.5;
          # <float> how much to dim the rest of the screen by when a special
          # workspace is open. [0.0 - 1.0]
          dim_special = 0.2;
          # <float> how much the dimaround window rule should dim by. [0.0 - 1.0]
          dim_around = 0.4;
          # <str> a path to a custom shader to be applied at the end of
          # rendering. See examples/screenShader.frag for an example.
          screen_shader = "";
          blur = {
            # <bool> enable kawase window background blur
            enabled = false;
            # <int>  blur size (distance, must be at least 1)
            size = 8;
            # <int>  the amount of passes to perform (must be at least 1)
            passes = 1;
            # <bool> make the blur layer ignore the opacity of the window
            ignore_opacity = true;
            # <bool> whether to enable further optimizations to the blur.
            # Recommended to leave on, as it will massively improve performance.
            new_optimizations = true;
            # <bool> if enabled, floating windows will ignore tiled windows
            # in their blur. Only available if new_optimizations is true.
            # Will reduce overhead on floating blur significantly.
            xray = false;
            # <float> how much noise to apply.
            # [0.0 - 1.0]
            noise = 0.0117;
            # <float> contrast modulation for blur.
            # [0.0 - 2.0]
            contrast = 0.8916;
            # <float> brightness modulation for blur.
            # [0.0 - 2.0]
            brightness = 0.8172;
            # <float> Increase saturation of blurred colors.
            # [0.0 - 1.0]
            vibrancy = 0.1696;
            # <float> How strong the effect of vibrancy is on dark areas .
            # [0.0 - 1.0]
            vibrancy_darkness = 0.0;
            # <bool> whether to blur behind the special workspace
            # (note: expensive)
            special = false;
            # <bool> whether to blur popups (e.g. right-click menus)
            popups = false;
            # <float> works like ignorealpha in layer rules. If pixel
            # opacity is below set value, will not blur.
            # [0.0 - 1.0]
            popups_ignorealpha = 0.2;
            # <bool> whether to blur input methods (e.g. fcitx5)
            # input_methods = false;
            # <float> works like ignorealpha in layer rules. If pixel
            # opacity is below set value, will not blur.
            # [0.0 - 1.0]
            # input_methods_ignorealpha = 0.2;
          };

          shadow = {
            # <bool> enable drop shadows on windows
            enabled = false;
            # <int> Shadow range (“size”) in layout px
            range = 4;
            # <int> in what power to render the falloff
            # (more power, the faster the falloff) [1 - 4]
            render_power = 3;
            # <bool> if enabled, will make the shadows sharp,
            # akin to an infinite render power
            sharp = false;
            # <bool> if true, the shadow will not be rendered
            # behind the window itself, only around it.
            ignore_window = true;
            # <color> shadow’s color. Alpha dictates shadow’s opacity.
            color = "0xee1a1a1a";
            # <color> inactive shadow color. (if not set, will fall back to color)
            color_inactive = "0xee1a1a1a";
            # <vec2> shadow’s rendering offset.
            # offset = "[0, 0]";
            # <float> shadow’s scale. [0.0 - 1.0]
            scale = 1.0;
          };
        };
        animations = {
          # More details about animations:
          # https://wiki.hyprland.org/Configuring/Animations/
          enabled = s.animations.enable;
          first_launch_animation = s.animations.firstLaunchAnimation;
        };
        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = s.input;
        cursor = {
          no_hardware_cursors = true;
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
        exec-once = s.execOnce;
        exec = s.exec;
        exec-shutdown = s.execShutdown;
        # Key bindings
        # https://wiki.hyprland.org/Configuring/Binds/
        bind = s.bind;
        # Flags:
        # m -> mouse, see below.
        # https://wiki.hyprland.org/Configuring/Binds/#mouse-binds
        bindm = s.bindm;
        # Flags:
        # e -> repeat, will repeat when held.
        # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
        bindel = s.bindel;
        # Flags:
        # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
        bindl = s.bindl;
      };
      plugins = [
        # hyprgrass - hyprland plugin for touch screen gestures
        # https://github.com/horriblename/hyprgrass
        # inputs.hyprgrass.packages.${pkgs.system}.default

        # hyprsplit - hyprland plugin for separate sets of workspaces on each monitor
        # https://github.com/shezdy/hyprsplit
        inputs.hyprsplit.packages.${pkgs.system}.default

        # hyprspace - Workspace overview plugin for Hyprland
        # https://github.com/KZDKM/Hyprspace
        # inputs.hyprspace.packages.${pkgs.system}.default
      ];
    };
    home.packages = [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      inputs.hyprland-contrib.packages.${pkgs.system}.hdrop
      inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad
      inputs.hyprland-contrib.packages.${pkgs.system}.try_swap_workspace
      pkgs.glm
      # an xprop replacement for hyprland
      pkgs.hyprprop
    ];
    gui.eww = {
      enable = true;
      bar.enable = true;
    };
    scripts.monitorswitch.enable = true;
  };
}
