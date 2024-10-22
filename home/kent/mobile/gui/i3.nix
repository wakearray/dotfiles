{ pkgs, lib, config, ... }:
{
  imports = [
    ./polybar.nix
  ];
  # i3
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          "1" = [{ class = "Alacritty"; }];
          "2" = [{ title = ".*Discord.*"; }];
          "3" = [{ title = ".*YouTube.*"; }];
          "4" = [{ class = ".*Firefox.*"; }];
          "5" = [{ class = ".*Firefox.*"; }];
          "6" = [{ class = ".*Firefox.*"; }];
          "10" = [{ title = ".*Tidal.*"; }];
        };
        bars = [
#          {
#            mode = "dock";
#            hiddenState = "hide";
#            position = "bottom";
#            workspaceButtons = true;
#            workspaceNumbers = true;
#            statusCommand = "${pkgs.i3status}/bin/i3status";
#            fonts = {
#              names = [ "SauceCodePro NFM" ];
#              style = "Regular";
#              size = 16.0;
#            };
#            trayOutput = "primary";
#            colors = {
#              background = "#000000";
#              statusline = "#ffffff";
#              separator = "#666666";
#              focusedWorkspace = {
#                border = "#4c7899";
#                background = "#285577";
#                text = "#ffffff";
#              };
#              activeWorkspace = {
#                border = "#333333";
#                background = "#5f676a";
#                text = "#ffffff";
#              };
#              inactiveWorkspace = {
#                border = "#333333";
#                background = "#222222";
#                text = "#888888";
#              };
#              urgentWorkspace = {
#                border = "#2f343a";
#                background = "#900000";
#                text = "#ffffff";
#              };
#              bindingMode = {
#                border = "#2f343a";
#                background = "#900000";
#                text = "#ffffff";
#              };
#            };
#          }
        ];
        fonts = {
          names = [ "SauceCodePro NFM" ];
          style = "Regular";
          size = 16.0;
        };
        keybindings =
        let
          modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Shift+e" = "exit";

        };
        startup = [
          { command = "alacritty"; }
          { command = "firefox"; }
          { # polybar
            command = "/home/kent/.config/i3/polybar.sh &";
            always = true;
            notification = false;
          }
        ];
        terminal = "alacritty";
        window = {
          border = 0;
          hideEdgeBorders = "both";
          titlebar = false;
        };
        workspaceAutoBackAndForth = true;
        focus.followMouse = false;
        menu = "${pkgs.dmenu}/bin/dmenu_run";
      };
    };
  };
}
