{ pkgs, config, ... }:
{
  imports = [
    ./polybar.nix
    ./rofi.nix
  ];
  # i3
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          "1: t" = [ { class = "Alacritty"; } ];
          "2: d" = [ { title = "Discord.*"; } ];
          "3: y" = [ { title = ".*YouTube.*"; } ];
          "4: f" = [ { class = "firefox"; } {class = "Navigator";} ];
          "5: a" = [  ];
          "6: b" = [  ];
          "7: c" = [  ];
          "8: d" = [  ];
          "9: e" = [  ];
          "10: t" = [ { title = ".*Tidal.*"; } ];
        };
        bars = [  ];
        defaultWorkspace = "workspace number 1";
        fonts = {
          names = [ "SauceCodePro NFM" ];
          style = "Regular";
          size = 16.0;
        };
        keycodebindings =
        let
          modifier = config.xsession.windowManager.i3.config.modifier;
        in {
          # '47' is the keycode for ';' according to xev
          "${modifier}+47" = "focus right";
          "${modifier}+Shift+47" = "move right";
        };
        keybindings =
        let
          menu     = config.xsession.windowManager.i3.config.menu;
          terminal = config.xsession.windowManager.i3.config.terminal;
          modifier = config.xsession.windowManager.i3.config.modifier;
        in {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";

          "${modifier}+j" = "focus left";
          "${modifier}+k" = "focus down";
          "${modifier}+l" = "focus up";
#          "${modifier}+\;" = "focus right";

          "${modifier}+Shift+j" = "move left";
          "${modifier}+Shift+k" = "move down";
          "${modifier}+Shift+l" = "move up";
#~          "${modifier}+Shift+\;" = "move right";

          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+a" = "focus parent";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          "${modifier}+Shift+1" =
            "move container to workspace number 1";
          "${modifier}+Shift+2" =
            "move container to workspace number 2";
          "${modifier}+Shift+3" =
            "move container to workspace number 3";
          "${modifier}+Shift+4" =
            "move container to workspace number 4";
          "${modifier}+Shift+5" =
            "move container to workspace number 5";
          "${modifier}+Shift+6" =
            "move container to workspace number 6";
          "${modifier}+Shift+7" =
            "move container to workspace number 7";
          "${modifier}+Shift+8" =
            "move container to workspace number 8";
          "${modifier}+Shift+9" =
            "move container to workspace number 9";
          "${modifier}+Shift+0" =
            "move container to workspace number 10";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";

          "${modifier}+r" = "mode resize";
          "${modifier}+Shift+e" = "exit";

        };
        startup = [
          { command = "alacritty"; }
          { command = "firefox"; }
          { # polybar
            command = "${config.home.file.".config/i3/polybar.sh".source} &";
            always = true;
            notification = false;
          }
          { # i3wsr - updates workspace names with app icons
            command = "${pkgs.i3wsr}/bin/i3wsr";
            always = true;
            notification = false;
          }
        ];
        terminal = "alacritty";
        window = {
          border = 0;
          hideEdgeBorders = "both";
          titlebar = false;
          commands = [
            {
              command = "move to workspace number 2";
              criteria = {
                title = "Discord.*";
              };
            }
            {
              command = "move to workspace number 3";
              criteria = {
                title = ".*YouTube.*";
              };
            }
            {
              command = "move to workspace number 10";
              criteria = {
                title = ".*Tidal.*";
              };
            }
          ];
        };
        workspaceAutoBackAndForth = true;
        focus = {
          followMouse = false;
          wrapping = "no";
        };
        menu = "${config.programs.rofi.finalPackage}/bin/rofi -show drun";
      };
    };
  };

  home = {
    packages = with pkgs; [
      # Work Space Renamer - Allows for changing the name based on the app
      # https://github.com/roosta/i3wsr
      i3wsr
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
  };

  xdg.configFile = {
    "i3wsr/config.toml" = {
      enable = true;
      force = true;
      source = pkgs.writers.writeTOML "config.toml" {
        "aliases.title" = {
          # "<window_title_regex>" = "<alias>";
          "Discord.*" = "discord";
          ".*YouTube.*" = "youtube";
          ".*Tidal.*" = "tidal";
          "Photopea.*" = "photopea";
          ".*Gmail.*" = "gmail";
        };
        "aliases.class" = {
          # "<window_class_regex>" = "<alias>";
          "Alacritty" = "alacritty";
          firefox = "firefox";
          darktable = "darktable";
          keepassxc = "keepass";
        };
        icons = {
          # alias = "icon";
          discord = "";
          youtube = "";
          tidal = "";
          photopea = "";
          gmail = "󰊫";
          alacritty = "";
          firefox = "󰈹";
          darktable = "󰄄";
          localsend = "󱥸";
          keepass = "";
        };
        general = {
          separator = " ";
          split_at = ":";
          default_icon = "";
        };
        options = {
          no_names = true;
          no_icon_names = true;
        };
      };
    };
  };
}
