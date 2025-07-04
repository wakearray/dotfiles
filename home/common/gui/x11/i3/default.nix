{ lib, pkgs, config, ... }:
let
  gui = config.gui;
  x11 = gui.x11;
  i3 = gui.wm.i3;
  polybar = gui.polybar;
  eww = gui.eww;

  colorSetModule = with lib; types.submodule {
    options = {
      border = mkOption {
        type = types.str;
        visible = false;
      };
      childBorder = mkOption {
        type = types.str;
        visible = false;
      };
      background = mkOption {
        type = types.str;
        visible = false;
      };
      text = mkOption {
        type = types.str;
        visible = false;
      };
      indicator = mkOption {
        type = types.str;
        visible = false;
      };
    };
  };

in
{
  imports = [
    ./i3wsr.nix
    ./i3launcher.nix
  ];

  options.gui.wm.i3 = with lib; {
    enable = mkEnableOption "Enable a very opinionated i3 config intended for use inside Termux.";

    modifier = mkOption {
      type = types.enum [ "Shift" "Control" "Mod1" "Mod2" "Mod3" "Mod4" "Mod5" ];
      default = "Mod4";
      description = ''
        A modifier key for use with various hotkeys. Available options are based on output of `xmodmap -pm`
        ```bash
        shift       Shift_L (0x32),  Shift_R (0x3e)
        lock        Caps_Lock (0x42)
        control     Control_L (0x25),  Control_R (0x69)
        mod1        Alt_L (0x40),  Meta_L (0xcd)
        mod2        Num_Lock (0x94)
        mod3
        mod4        Super_R (0x86),  Super_L (0xce),  Hyper_L (0xcf)
        mod5        ISO_Level3_Shift (0x5c),  ISO_Level3_Shift (0x6c),  Mode_switch (0x85),  Mode_switch (0xcb)
        ```
        Due to home manager's implementation, the available options are slightly different.
      '';
    };

    colors = mkOption {
      type = types.submodule {
        options = {
          background = mkOption {
            type = types.str;
            default = "#ffffff";
            description = ''
              Background color of the window. Only applications which do not cover
              the whole area expose the color.
            '';
          };

          focused = mkOption {
            type = colorSetModule;
            default = {
              border = "#4c7899";
              background = "#285577";
              text = "#ffffff";
              indicator = "#2e9ef4";
              childBorder = "#285577";
            };
            description = "A window which currently has the focus.";
          };

          focusedInactive = mkOption {
            type = colorSetModule;
            default = {
              border = "#333333";
              background = "#5f676a";
              text = "#ffffff";
              indicator = "#484e50";
              childBorder = "#5f676a";
            };
            description = ''
              A window which is the focused one of its container,
              but it does not have the focus at the moment.
            '';
          };

          unfocused = mkOption {
            type = colorSetModule;
            default = {
              border = "#333333";
              background = "#222222";
              text = "#888888";
              indicator = "#292d2e";
              childBorder = "#222222";
            };
            description = "A window which is not focused.";
          };

          urgent = mkOption {
            type = colorSetModule;
            default = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
              indicator = "#900000";
              childBorder = "#900000";
            };
            description = "A window which has its urgency hint activated.";
          };

          placeholder = mkOption {
            type = colorSetModule;
            default = {
              border = "#000000";
              background = "#0c0c0c";
              text = "#ffffff";
              indicator = "#000000";
              childBorder = "#0c0c0c";
            };
            description = ''
              Background and text color are used to draw placeholder window
              contents (when restoring layouts). Border and indicator are ignored.
            '';
          };
        };
      };
      default = { };
      description = ''
        Color settings. All color classes can be specified using submodules
        with 'border', 'background', 'text', 'indicator' and 'childBorder' fields
        and RGB color hex-codes as values. See default values for the reference.
        Note that '${moduleName}.config.colors.background' parameter takes a single RGB value.

        See <https://i3wm.org/docs/userguide.html#_changing_colors>.
      '';
    };
  };

  config = lib.mkIf (gui.enable && (x11.enable && i3.enable)) {
    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-rounded;
        config = {
          modifier = i3.modifier;

          assigns = lib.mkOverride 1001 {
            "$pws_1" = [ { class = "Alacritty";   } ];
            "$pws_2" = [ { title = "Discord.*";   } { class = "Signal";   } ];
            "$pws_3" = [ { title = ".*YouTube.*"; } ];
            "$pws_4" = [ { class = "firefox";     } { class = "Navigator"; } ];
            "$pws_5" = [  ];
            "$pws_6" = [  ];
            "$pws_7" = [  ];
            "$pws_8" = [  ];
            "$pws_9" = [ { title = ".*Tidal.*";  } ];
          };

          bars = [  ];

          defaultWorkspace = "$pws_1";

          fonts = {
            names = [ "SauceCodePro NFM" ];
            style = "Regular";
            size = 16.0;
          };

          keybindings =
          let
          # rofiTodo     = "${config.home.homeDirectory}.local/bin/todofi.sh";
            menu         = config.xsession.windowManager.i3.config.menu;
            quitPolybar  = "${config.home.homeDirectory}.config/polybar/quit_polybar.sh";
            modifier     = config.xsession.windowManager.i3.config.modifier;
          in lib.mkOverride 1001 {
            "${modifier}+q"       = "kill";
            "${modifier}+d"       = "exec ${menu}";
          # "${modifier}+t"       = "exec ${rofiTodo}";

            "${modifier}+Left"    = "focus left";
            "${modifier}+Down"    = "focus down";
            "${modifier}+Up"      = "focus up";
            "${modifier}+Right"   = "focus right";

            "${modifier}+Shift+Left"  = "move left";
            "${modifier}+Shift+Down"  = "move down";
            "${modifier}+Shift+Up"    = "move up";
            "${modifier}+Shift+Right" = "move right";

            "${modifier}+h"       = "split h";
            "${modifier}+v"       = "split v";
            "${modifier}+f"       = "fullscreen toggle";

            # $mod + Alt + s
            "${modifier}+mod1+s"  = "layout stacking";
            "${modifier}+g"       = "layout tabbed";
            "${modifier}+e"       = "layout toggle split";

            "${modifier}+t"       = "floating toggle";
            "${modifier}+p"       = "sticky toggle";
            # Toggle focus between floating and tiled
            "${modifier}+space"   = "focus mode_toggle";

            "${modifier}+a"       = "focus parent";

            "${modifier}+s"       = "move scratchpad";
            "${modifier}+Shift+s" = "scratchpad show";

            "${modifier}+1"       = "workspace number $pws_1";
            "${modifier}+2"       = "workspace number $pws_2";
            "${modifier}+3"       = "workspace number $pws_3";
            "${modifier}+4"       = "workspace number $pws_4";
            "${modifier}+5"       = "workspace number $pws_5";
            "${modifier}+6"       = "workspace number $pws_6";
            "${modifier}+7"       = "workspace number $pws_7";
            "${modifier}+8"       = "workspace number $pws_8";
            "${modifier}+9"       = "workspace number $pws_9";

            "${modifier}+Shift+1" =
              "move container to workspace number $pws_1";
            "${modifier}+Shift+2" =
              "move container to workspace number $pws_2";
            "${modifier}+Shift+3" =
              "move container to workspace number $pws_3";
            "${modifier}+Shift+4" =
              "move container to workspace number $pws_4";
            "${modifier}+Shift+5" =
              "move container to workspace number $pws_5";
            "${modifier}+Shift+6" =
              "move container to workspace number $pws_6";
            "${modifier}+Shift+7" =
              "move container to workspace number $pws_7";
            "${modifier}+Shift+8" =
              "move container to workspace number $pws_8";
            "${modifier}+Shift+9" =
              "move container to workspace number $pws_9";

            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+r" = "restart";

            "${modifier}+r"       = "mode resize";
            "${modifier}+Shift+q" = "exit";
            "${modifier}+Ctrl+q"  = "exec ${quitPolybar}";
          };

          modes = {
            resize = {
              Down = "resize grow height 10 px or 10 ppt";
              Escape = "mode default";
              Left = "resize shrink width 10 px or 10 ppt";
              Return = "mode default";
              Right = "resize grow width 10 px or 10 ppt";
              Up = "resize shrink height 10 px or 10 ppt";
            };
          };

          startup = lib.mkOverride 1001 [
            { command = "${pkgs.alacritty}/bin/alacritty"; }
            { command = "firefox"; }
            (lib.mkIf polybar.enable { # polybar
              command = "${config.home.file.".config/polybar/polybar.sh".source} &";
              always = true;
              notification = false;
            })
            (lib.mkIf polybar.enable { # i3wsr - updates workspace names with app icons
              command = "${pkgs.i3wsr-3}/bin/i3wsr";
              always = true;
              notification = false;
            })
            (lib.mkIf eww.enable { # launch eww
              command = "pkill eww && ${pkgs.eww}/bin/eww -c ${config.xdg.configHome}/eww/bar open bar --id mon_0 --screen 0 --arg width=\"100%\" --arg height=\"2%\" --arg offset=\"0\"";
              always = true;
              notification = false;
            })
            (lib.mkIf eww.enable { # launch eww
              command = "~/.config/eww/scripts/i3_listen_active_workspace.sh > /dev/null 2>&1 &";
              always = true;
              notification = false;
            })
            (lib.mkIf (eww.enable && eww.battery.enable) { # launch eww battery monitoring script
              command = "${pkgs.bash}/bin/bash ${config.xdg.configHome}/eww/scripts/battery.sh > /dev/null 2>&1 &";
              always = true;
              notification = false;
            })
          ];

          terminal = lib.mkOverride 1001 "${pkgs.alacritty}/bin/alacritty";

          window = lib.mkOverride 1001 {
            border = 3;
            titlebar = false;
            commands = [
              {
                command = "move to workspace number $pws_2";
                criteria = {
                  title = "Discord .*";
                };
              }
              {
                command = "sticky enable";
                criteria = {
                  floating_from = "user";
                };
              }
              {
                command = "sticky enable";
                criteria = {
                  floating = true;
                  title = "Picture-in-Picture";
                };
              }
              {
                command = "move to workspace number $pws_3";
                criteria = {
                  title = ".* - YouTube .*";
                };
              }
              {
                command = "move to workspace number $pws_9";
                criteria = {
                  title = ".*Tidal.*";
                };
              }
            ];
          };

          workspaceAutoBackAndForth = lib.mkOverride 1001 true;

          focus = lib.mkOverride 1001 {
            followMouse = false;
            wrapping = "no";
          };

          menu = "${config.programs.rofi.finalPackage}/bin/rofi -show drun";

          gaps = {
            outer = 12;
            inner = 5;
          };

          colors = {
            background      = i3.colors.background;
            focused         = i3.colors.focused;
            focusedInactive = i3.colors.focusedInactive;
            placeholder     = i3.colors.placeholder;
            unfocused       = i3.colors.unfocused;
            urgent          = i3.colors.urgent;
          };

          floating = {
            # Floating windows border width.
            border = 3;
            # List of criteria for windows that should be opened in a floating mode.
            criteria = [
              { title = "Picture-in-Picture"; class = "firefox"; }
            ];
            # Modifier key or keys that can be used to drag floating windows.
            modifier = i3.modifier;
            # Whether to show floating window titlebars.
            titlebar = false;
          };
        };
      extraConfig = lib.mkOverride 1001 ''
  set $pws_1 "1: 4a70"
  set $pws_2 "2: d772"
  set $pws_3 "3: 91b3"
  set $pws_4 "4: 4a1d"
  set $pws_5 "5: bfa0"
  set $pws_6 "6: 4fcd"
  set $pws_7 "7: 742e"
  set $pws_8 "8: f458"
  set $pws_9 "9: 3107"

  border_radius 5
      '';
      };
    };

    home = {
      packages = with pkgs; [
        # Handles hiding terminal windows that launch applications
        # https://github.com/jamesofarrell/i3-swallow
        i3-swallow
        # Commands for saving and restoring sessions
        # https://github.com/JonnyHaystack/i3-resurrect
        i3-resurrect
        # Shortcuts for opening/moving windows to next empty workspace
        # https://github.com/JohnDowson/i3-open-next-ws
        i3-open-next-ws
      ];
      shellAliases = {
        # This is only necessary on Android, but I also don't intend to enable i3 on anything else.
        starti3 = "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4713 && dbus-launch --exit-with-session i3";
      };
    };

    gui = {
      rofi.enable = lib.mkDefault true;
      wm.i3.i3wsr.enable = lib.mkDefault true;
    };
  };
}
