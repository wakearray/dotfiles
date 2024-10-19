{ pkgs, lib, config, ... }:
{
  # i3
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          "1: Alacritty" = [{ class = "Alacritty"; }];
          "2: Discord" = [{ class = "Discord"; }];
          "3: Firefox" = [{ class = "Firefox"; }];
        };
        bars = [
          {
            mode = "dock";
            hiddenState = "hide";
            position = "bottom";
            workspaceButtons = true;
            workspaceNumbers = true;
            statusCommand = "${pkgs.i3status}/bin/i3status";
            fonts = {
              names = [ "SauceCodePro NFM" ];
              style = "Regular";
              size = 16.0;
            };
            trayOutput = "primary";
            colors = {
              background = "#000000";
              statusline = "#ffffff";
              separator = "#666666";
              focusedWorkspace = {
                border = "#4c7899";
                background = "#285577";
                text = "#ffffff";
              };
              activeWorkspace = {
                border = "#333333";
                background = "#5f676a";
                text = "#ffffff";
              };
              inactiveWorkspace = {
                border = "#333333";
                background = "#222222";
                text = "#888888";
              };
              urgentWorkspace = {
                border = "#2f343a";
                background = "#900000";
                text = "#ffffff";
              };
              bindingMode = {
                border = "#2f343a";
                background = "#900000";
                text = "#ffffff";
              };
            };
          }
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
          { command = "nix run --impure github:nix-community/nixGL -- alacritty"; }
          { command = "firefox"; }
        ];
        terminal = "nix run --impure github:nix-community/nixGL -- alacritty";
        window = {
          border = 0;
          hideEdgeBorders = "both";
          titlebar = false;
        };
        workspaceAutoBackAndForth = true;
      };
    };
  };

  programs.i3status = {
    general = {
      colors =  true;
      interval =  5;
    };

    modules = {
      load = {
        position =  1;
        settings = { format =  "%1min"; };
      };

      memory = {
        position =  2;
        settings = {
          format =  "%used | %available";
          threshold_degraded =  "1G";
          format_degraded =  "MEMORY < %available";
        };
      };

      "tztime local" = {
        position =  3;
        settings = { format =  "%m-%d %I:%M"; };
      };
    };
  };
}
