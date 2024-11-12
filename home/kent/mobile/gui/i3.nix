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
          "$pws_1" = [ { class = "Alacritty"; } ];
          "$pws_2" = [ { title = "Discord.*"; } ];
          "$pws_3" = [ { title = ".*YouTube.*"; } ];
          "$pws_4" = [ { class = "firefox"; } {class = "Navigator";} ];
          "$pws_5" = [  ];
          "$pws_6" = [  ];
          "$pws_7" = [  ];
          "$pws_8" = [  ];
          "$pws_9" = [  ];
          "$pws_10" = [ { title = ".*Tidal.*"; } ];
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
          rofi_todo  = "${pkgs.todofi-sh}/bin/todofi.sh";
          #rofi_pass  = "";
          #rofi_emoji = "${config.programs.rofi.finalPackage}/bin/rofi -show emoji";
          menu       = config.xsession.windowManager.i3.config.menu;
          terminal   = config.xsession.windowManager.i3.config.terminal;
          modifier   = config.xsession.windowManager.i3.config.modifier;
        in {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+t" = "exec ${rofi_todo}";

          "${modifier}+j" = "focus left";
          "${modifier}+k" = "focus down";
          "${modifier}+l" = "focus up";

          "${modifier}+Shift+j" = "move left";
          "${modifier}+Shift+k" = "move down";
          "${modifier}+Shift+l" = "move up";

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

          "${modifier}+1" = "workspace number $pws_1";
          "${modifier}+2" = "workspace number $pws_2";
          "${modifier}+3" = "workspace number $pws_3";
          "${modifier}+4" = "workspace number $pws_4";
          "${modifier}+5" = "workspace number $pws_5";
          "${modifier}+6" = "workspace number $pws_6";
          "${modifier}+7" = "workspace number $pws_7";
          "${modifier}+8" = "workspace number $pws_8";
          "${modifier}+9" = "workspace number $pws_9";
          "${modifier}+0" = "workspace number $pws_10";

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
          "${modifier}+Shift+0" =
            "move container to workspace number $pws_10";

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
              command = "move to workspace number $pws_2";
              criteria = {
                title = "Discord .*";
              };
            }
            {
              command = "move to workspace number $pws_3";
              criteria = {
                title = ".* - YouTube .*";
              };
            }
            {
              command = "move to workspace number $pws_10";
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
    extraConfig = ''
set $pws_1 "1: term"
set $pws_2 "2: disc"
set $pws_3 "3: yout"
set $pws_4 "4: fire"
set $pws_5 "5: fire"
set $pws_6 "6: fire"
set $pws_7 "7: fire"
set $pws_8 "8: fire"
set $pws_9 "9: dark"
set $pws_10 "10: tida"
    '';
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
      text = ''
[icons]
Alacritty = ""
darktable = "󰄄"
discord = ""
firefox = "󰈹"
gmail = "󰊫"
keepassxc = ""
photopea = ""
Signal = "󰭹"
tidal = ""
youtube = ""

[aliases.name]
".* - YouTube .*" = "youtube"
".*Gmail.*" = "gmail"
".*Tidal.*" = "tidal"
"Photopea.*" = "photopea"
"^Discord .*" = "discord"

[options]
no_icon_names = true
no_names = true

[general]
default_icon = ""
separator = " "
split_at = ":"
      '';
    };
  };
}
