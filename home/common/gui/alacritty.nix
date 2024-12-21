{ lib, config, pkgs, ... }:
let
  cfg = config.gui.alacritty;
in
{
  options.gui.alacritty = with lib; {
    enable = mkEnableOption "Enable an opinionated Alacritty config.";

    colors = mkOption {
      type = types.attrs;
      default = {
        # Gruvbox Material Medium Dark
        primary = {
          background = "0x282828"; # #282828
          foreground = "0xd4be98"; # #d4be98
        };
        normal = {
          black = "0x3c3836";    # #3c3836
          red = "0xea6962";      # #ea6962
          green = "0xa9b665";    # #a9b665
          yellow = "0xd8a657";   # #d8a657
          blue = "0x7daea3";     # #7daea3
          magenta = "0xd3869b";  # #d3869b
          cyan = "0x89b482";     # #89b482
          white = "0xd4be98";    # #d4be98
        };
        bright = {
          black = "0x3c3836";   # #3c3836
          red = "0xea6962";     # #ea6962
          green = "0xa9b665";   # #a9b665
          yellow = "0xd8a657";  # #d8a657
          blue = "0x7daea3";    # #7daea3
          magenta = "0xd3869b"; # #d3869b
          cyan = "0x89b482";    # #89b482
          white = "0xd4be98";   # #d4be98
        };
      };
      description = "An attribute set of attribute sets of strings of colors as defined by alacritty documentation. https://alacritty.org/config-alacritty.html#colors";
    };
    fonts = mkOption {
      type = types.attrs;
      default = {
        normal =  {
          family = "SauceCodePro NFM";
          style = "Regular";
        };
        bold = {
          family = "SauceCodePro NFM";
          style = "SemiBold";
        };
        italic = {
          family = "SauceCodePro NFM";
          style = "Italic";
        };
        bold_italic = {
          family = "SauceCodePro NFM";
          style = "SemiBold Italic";
        };
      };
      description = "An attribute set of attribute sets of strings of fonts as defined by alacritty documentation. https://alacritty.org/config-alacritty.html#font";
    };
  };
  config = lib.mkIf cfg.enable {
    programs =  {
      # alacritty - A cross-platform, OpenGL terminal emulator
      # https://github.com/alacritty/alacritty
      alacritty = {
        enable = true;
        settings = {
          selection = {
            save_to_clipboard = true;
          };
          cursor = {
            style = {
              shape = "Underline";
              blinking = "Off";
            };
          };
          terminal = {
            shell = {
              program = "${pkgs.zsh}/bin/zsh";
              args = [ "--login" "-c" "zellij" ];
            };
            osc52 = "CopyPaste";
          };
          mouse = {
            bindings = [{
              mouse = "Middle";
              action = "Paste";
            }];
          };
          font = cfg.fonts;
          colors = cfg.colors;
        };
      };
    };
  };
}
