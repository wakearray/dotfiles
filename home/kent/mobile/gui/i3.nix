{ lib, config, ... }:
{
  # i3
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        assigns = {
          "1: term" = [{ class = "Alacritty"; }];
          "2: web" = [{ class = "^Firefox$"; }];
        };
        #bars = [
          #
        #];
        fonts = {
          names = [ "SauceCodePro NFM" ];
          style = "Regular";
          size = 12.0;
        };
        keybindings =
        let
          modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+Shift+e" = "exit";
        };
        startup = [
          { command = "nglu alacritty"; }
          { command = "firefox-esr"; }
        ];
        terminal = "nglu alacritty";
        window = {
          border = 0;
          hideEdgeBorders = "both";
          titlebar = false;
        };
        workspaceAutoBackAndForth = true;
      };
    };
  };
}
