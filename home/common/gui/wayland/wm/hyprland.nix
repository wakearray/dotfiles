{ lib, config, pkgs, inputs, ... }:
let
  gui = config.gui;
  wayland = gui.wayland;
  hyprland = config.home.wm.hyprland;
  s = hyprland.settings;
in
{
  imports = [ ./hypridle.nix ];

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
      overview = {
        panelColor = mkOption {
          type = types.str;
          default = "0xff444444";
          description = "Color of the border for inactive windows. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
        panelBorderColor = mkOption {
          type = types.str;
          default = "0xff444444";
          description = "Color of the border for inactive windows. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
        workspaceActiveBackground = mkOption {
          type = types.str;
          default = "0xff444444";
          description = "Color of the border for inactive windows. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
        workspaceInactiveBackground = mkOption {
          type = types.str;
          default = "0xff444444";
          description = "Color of the border for inactive windows. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
        workspaceActiveBorder = mkOption {
          type = types.str;
          default = "0xff444444";
          description = "Color of the border for inactive windows. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
        };
        workspaceInactiveBorder = mkOption {
          type = types.str;
          default = "0xff444444";
          description = "Color of the border for inactive windows. Color is type gradient as described here: https://wiki.hyprland.org/Configuring/Variables/#:~:text=gradient,0deg";
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
        default = [
          "group set, class:firefox, title:^(.*)!(Mozilla Firefox Private Browsing)$"
          "float, class:(firefox), title:(Picture-in-Picture)"
          "pin, class:(firefox), title:(Picture-in-Picture), floating:1"
          "size 20% 20%, class:(firefox), title:(Picture-in-Picture), floating:1, pinned:1"
        ];
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
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_0 --screen 0 --arg width=\"100%\" --arg offset=\"0\""
          "${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_1 --screen 1 --arg width=\"100%\" --arg offset=\"9\""
          # "${pkgs.hyprland-monitor-attached}/bin/hyprland-monitor-attached "
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
      execr = mkOption {
        type = types.listOf types.str;
        default = [
          "${pkgs.eww}/bin/eww close-all && pkill eww"
        ];
        description = "A list of command line arguments you want run when hyprland is reloaded.";
      };
      execShutdown = mkOption {
        type = types.listOf types.str;
        default = [
          "${pkgs.eww}/bin/eww close-all && pkill eww"
        ];
        description = "A list of command line arguments you want run when hyprland exits.";
      };
      bindr = mkOption {
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

          # Bring up the rofi menu for clipboard history
          "$mod      , V       , exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

          # Finds all windows that are in invalid workspaces and moves them
          # to the current workspace. Useful when unplugging monitors.
          # "$mod SHIFT, G       , split:grabroguewindows"
          # Close the active app
          "$mod      , Q       , killactive"
          # Toggle floating on the currently active app
          "$mod      , T       , togglefloating"
          # Toggle grouping on the currently active app
          "$mod      , G       , togglegroup"
          # Move window out of group
          "$mod SHIFT, G       , moveoutofgroup"

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
          "$mod      , L       , exec, systemctl suspend && gtklock"

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

          "$mod   ALT, left    , moveintogroup, l"
          "$mod   ALT, right   , moveintogroup, r"
          "$mod   ALT, up      , moveintogroup, u"
          "$mod   ALT, down    , moveintogroup, d"
        ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, split:workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, split:movetoworkspacesilent, ${toString ws}"
          ])9)
        );
        description = "Key bindings the trigger on release as described here: https://wiki.hyprland.org/Configuring/Binds/ use $mod to reference your assigned mod key.";
      };
      bindsr = mkOption {
        type = types.listOf types.str;
        default = [
          # Move the active window in or out of a group with the arrow keys
          # Action performed depends on whether there is a group in the direction
          #"$mod SHIFT, G&left    , movewindoworgroup, l"
          #"$mod SHIFT, G&right   , movewindoworgroup, r"
          #"$mod SHIFT, G&up      , movewindoworgroup, u"
          #"$mod SHIFT, G&down    , movewindoworgroup, d"

        ];
        description = "Multiple arbitrary key bindings that trigger on key release as described here: https://wiki.hyprland.org/Configuring/Binds/#keysym-combos

Use $mod to reference your assigned mod key and separate each key or mod in a multikey/multi-mod bind, using `&` with no spaces.

Note: Normally this would just be `binds` and not `bindsr`, but that already exists as an attribute set of other keybinding related options, due to the.. *interesting* choices the hyprland devs made.";
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

  config = lib.mkIf (gui.enable && (wayland.enable && (hyprland.enable))) {
    wayland.windowManager.hyprland = {
      enable = true;
      # Disabled due to using UWSM
      # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/#uwsm
      systemd.enable = false;
      settings = {
        "$mod" = "${hyprland.modKey}";
        # https://wiki.hyprland.org/Configuring/Monitors/
        monitor = s.monitors;
        windowrulev2 = s.windowRules;
        plugin = {
          overview = {
            # Colors
            panelColor = hyprland.colors.overview.panelColor;
            panelBorderColor = hyprland.colors.overview.panelBorderColor;
            workspaceActiveBackground = hyprland.colors.overview.workspaceActiveBackground;
            workspaceInactiveBackground = hyprland.colors.overview.workspaceInactiveBackground;
            workspaceActiveBorder = hyprland.colors.overview.workspaceActiveBorder;
            workspaceInactiveBorder = hyprland.colors.overview.workspaceInactiveBorder;
            dragAlpha = 0.4; # overrides the alpha of window when dragged in overview (0 - 1, 0 = transparent, 1 = opaque)
            disableBlur = true;

            # Layout

            #panelHeight = ;
            #panelBorderWidth = ;
            onBottom = false; # whether if panel should be on bottom instead of top
            #workspaceMargin = ; # spacing of workspaces with eachother and the edge of the panel
            #reservedArea = ; # padding on top of the panel, for Macbook camera notch
            #workspaceBorderSize = ;
            centerAligned = true; # whether if workspaces should be aligned at the center (KDE / macOS style) or at the left (Windows style)
            hideBackgroundLayers = true; # do not draw background and bottom layers in overview
            hideTopLayers = true; # do not draw top layers in overview
            hideOverlayLayers = true; # do not draw overlay layers in overview
            #hideRealLayers = ; # whether to hide layers in actual workspace
            #drawActiveWorkspace = ; # draw the active workspace in overview as-is
            overrideGaps = false; # whether if overview should override the layout gaps in the current workspace using the following values
            gapsIn = 0;
            gapsOut = 0;
            affectStrut = true; # whether the panel should push window aside, disabling this option also disables overrideGaps

            # Animation

            # The panel uses the windows curve for a slide-in animation
            #overrideAnimSpeed = ; # to override the animation speed

            # Behaviors
            autoDrag = true; # mouse click always drags window when overview is open
            autoScroll = true; # mouse scroll on active workspace area always switch workspace
            exitOnClick = true; # mouse click without dragging exits overview
            switchOnDrop = false; # switch to the workspace when a window is droppped into it
            exitOnSwitch = false; # overview exits when overview is switched by clicking on workspace view or by switchOnDrop
            showNewWorkspace = false; # add a new empty workspace at the end of workspaces view
            showEmptyWorkspace = true; # show empty workspaces that are inbetween non-empty workspaces
            showSpecialWorkspace = false; # defaults to false
            disableGestures = false;
            reverseSwipe = false; # reverses the direction of swipe gesture, for macOS peeps?
            exitKey = 1; # key used to exit overview mode (default: Escape). Leave empty to disable keyboard exit.
          };
          touch_gestures = {
            # The default sensitivity is probably too low on tablet screens,
            # I recommend turning it up to 4.0
            sensitivity = 1.0;

            # must be >= 3
            workspace_swipe_fingers = 3;

            # switching workspaces by swiping from an edge,
            # this is separate from workspace_swipe_fingers
            # and can be used at the same time
            # possible values: l, r, u, or d
            # to disable it set it to anything else
            workspace_swipe_edge = "d";

            # in milliseconds
            long_press_delay = 400;

            # resize windows by long-pressing on window borders and gaps.
            # If general:resize_on_border is enabled,
            # general:extend_border_grab_area is used for floating windows
            resize_on_border_long_press = true;

            # in pixels, the distance from the edge that is considered an edge
            edge_margin = 10;

            # emulates touchpad swipes when swiping in a direction
            # that does not trigger workspace swipe.
            # ONLY triggers when finger count is equal to workspace_swipe_fingers
            #
            # might be removed in the future in favor of event hooks
            emulate_touchpad_swipe = false;

            experimental = {
              # send proper cancel events to windows instead of hacky touch_up events,
              # NOT recommended as it crashed a few times,
              # once it's stabilized I'll make it the default
              send_cancel = 0;
            };
          };
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
          "col.inactive_border" = hyprland.colors.general.inactiveBorder;
          # border color for the active window
          "col.active_border" = hyprland.colors.general.activeBorder;
          # inactive border color for window that cannot be added to a group
          "col.nogroup_border" = hyprland.colors.general.noGroupBorder;
          # active border color for window that cannot be added to a group
          "col.nogroup_border_active" = hyprland.colors.general.noGroupAorderActive;
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
        execr = s.execr;
        exec-shutdown = s.execShutdown;
        # Key bindings
        # https://wiki.hyprland.org/Configuring/Binds/
        # Flags:
        # s -> separate, will arbitrarily combine keys between each mod/key
        # r -> release, will trigger on release of a key.
        bindsr = s.bindsr;
        # Flags:
        # r -> release, will trigger on release of a key.
        bindr = s.bindr;
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
      plugins = with pkgs; [
        # hyprgrass - hyprland plugin for touch screen gestures
        # https://github.com/horriblename/hyprgrass
        # inputs.hyprgrass.packages.${pkgs.system}.default
        hyprlandPlugins.hyprgrass

        # hyprsplit - hyprland plugin for separate sets of workspaces on each monitor
        # https://github.com/shezdy/hyprsplit
        #inputs.hyprsplit.packages.${pkgs.system}.default
        hyprlandPlugins.hyprsplit

        # hyprspace - Workspace overview plugin for Hyprland
        # https://github.com/KZDKM/Hyprspace
        # inputs.hyprspace.packages.${pkgs.system}.default
        hyprlandPlugins.hyprspace
      ];
    };
    home.packages = with pkgs; [
      # Screen shot utility for hyprland
      grimblast

      # tdrop behavior for hyprland
      hdrop

      # Display arragement UI for hyprland
      nwg-displays

      # Math lib, not sure why I have this...
      glm

      # An xprop replacement for hyprland
      hyprprop

      # Changes the cursor
      hyprcursor

      # Automatically run a script when a monitor connects (or disconnects) in Hyprland
      # To use, add this to the the hyprland.conf
      # exec-once = ~/.cargo/bin/hyprland-monitor-attached PATH_TO_ATTACHED_SHCRIPT.sh [PATH_TO_DETACHED_SHCRIPT.sh]
      hyprland-monitor-attached
    ] ++ [
        inputs.hyprland-contrib.packages.${pkgs.system}.try_swap_workspace
        inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad
      ];
    gui.eww = {
      bar.enable = lib.mkDefault true;
    };
    scripts.monitorSwitch.enable = true;
    home.wm.hypridle.enable = true;
    home.pointerCursor = {
      hyprcursor = {
        enable = lib.mkDefault true;
        size = lib.mkDefault 36;
      };
    };
  };
}
