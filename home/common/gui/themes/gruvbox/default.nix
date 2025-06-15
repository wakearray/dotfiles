{ lib, config, pkgs, ... }:
let
  # The expression colors includes all colors
  # found in the gruvbox material medium dark theme.
  #
  # https://github.com/sainnhe/gruvbox-material
  #
  # Below are all the color methods supported by GTK
  #
  # Names: "transparent", "red"
  # RGB: "rgb(128,57,0)"
  # RGB with alpha: "rgba(10%,20%,30%,0.5)"
  # 8-bit Hex: "#ff00cc"
  # 16-bit Hex: "#ffff0000cccc"
  colors = {
    bg_dim           = "#1B1B1B";
    bg_0             = "#282828";
    bg_1             = "#32302F";
    bg_2             = "#45403D";
    bg_3             = "#5A524C";
    bg_statusline_1  = "#32302F";
    bg_statusline_2  = "#3A3735";
    bg_statusline_3  = "#504945";
    bg_diff_green    = "#34381B";
    bg_diff_red      = "#402120";
    bg_diff_blue     = "#0E363E";
    bg_visual_green  = "#3B4439";
    bg_visual_red    = "#4C3432";
    bg_visual_blue   = "#374141";
    bg_visual_yellow = "#4F422E";
    bg_current_word  = "#3C3836";
    fg_0             = "#D4BE98";
    fg_1             = "#DDC7A1";
    fg_red           = "#EA6962";
    fg_orange        = "#E78A4E";
    fg_yellow        = "#D8A657";
    fg_green         = "#A9B665";
    fg_aqua          = "#89B482";
    fg_blue          = "#7DAEA3";
    fg_purple        = "#D3869B";
    fg_grey_0        = "#7C6F64";
    fg_grey_1        = "#928374";
    fg_grey_2        = "#A89984";
  };
  cfg = config.gui.themes.gruvbox;
in
{
  options.gui.themes.gruvbox = with lib; {
    enable = mkEnableOption "Enable the Gruvbox theme.";

    cursorSize = mkOption {
      type = types.int;
      default = 16;
      description = "The size of both xcursor and hyprcursor.";
    };
  };
  config = lib.mkIf cfg.enable {
    gui = {
      wm = {
        i3.colors = {
          background = colors.fg_0;
          focused = {
            border = colors.fg_orange;
            background = colors.fg_yellow;
            text = colors.fg_0;
            indicator = colors.fg_orange;
            childBorder = colors.fg_yellow;
          };
          focusedInactive = {
            border = colors.bg_statusline_1;
            background = colors.bg_statusline_3;
            text = colors.fg_0;
            indicator = colors.bg_statusline_3;
            childBorder = colors.bg_statusline_1;
          };
          unfocused = {
            border      = colors.bg_statusline_1; # #32302F
            background  = colors.bg_dim;          # #1B1B1B
            text        = colors.fg_0;            # #D4BE98
            indicator   = colors.bg_2;            # #45403D
            childBorder = colors.bg_dim;          # #1B1B1B
          };
          urgent = {
            border = colors.bg_diff_red;
            background = colors.fg_red;
            text = colors.fg_0;
            indicator = colors.fg_red;
            childBorder = colors.fg_red;
          };
          placeholder = {
            border = colors.bg_dim;
            background = colors.bg_0;
            text = colors.fg_0;
            indicator = colors.bg_dim;
            childBorder = colors.bg_0;
          };
        };
      };
      eww = {
        bar = {
          colors = {
            text = colors.fg_1;
            bar-fg = colors.fg_1;
            bar-bg = colors.bg_1;
            tooltip-fg = colors.fg_1;
            tooltip-bg = colors.bg_1;
            metric-fg = colors.fg_orange;
            metric-bg = colors.bg_2;
            workspace-active = colors.fg_orange;
            workspace-inactive = colors.fg_yellow;
          };
        };
        icons.colors = {
          battery-full = colors.fg_green;
          battery-charging = colors.fg_yellow;
          battery-discharging = colors.fg_yellow;
          battery-low = colors.fg_orange;
          battery-critical = colors.fg_red;
          volume-mute = colors.fg_grey_2;
          volume-low = colors.fg_yellow;
          volume-medium = colors.fg_yellow;
          volume-high = colors.fg_yellow;
          volume-critical-high = colors.fg_red;
          memory-useage-low = colors.fg_yellow;
          memory-useage-medium = colors.fg_yellow;
          memory-useage-high = colors.fg_orange;
          memory-useage-critical-high = colors.fg_red;
          brightness-low = colors.fg_yellow;
          brightness-medium = colors.fg_yellow;
          brightness-high = colors.fg_yellow;
        };
      };
      rofi = {
        theme =
        let
          # Use `mkLiteral` for string-like values that should show without
          # quotes, e.g.:
          # {
          #   foo = "abc"; => foo: "abc";
          #   bar = mkLiteral "abc"; => bar: abc;
          # };
          inherit (config.lib.formats.rasi) mkLiteral;
          primaryAlpha   = "F2";
          secondaryAlpha = "80";
        in {
          # ROUNDED THEME FOR ROFI */
          # Author: Newman Sanchez (https://github.com/newmanls) */
          "*" = {
            bg0 = mkLiteral (colors.bg_0 + primaryAlpha);
            bg1 = mkLiteral colors.bg_1;
            bg2 = mkLiteral (colors.bg_2 + secondaryAlpha);
            bg3 = mkLiteral (colors.fg_yellow + primaryAlpha);
            fg0 = mkLiteral colors.fg_0;
            fg1 = mkLiteral colors.fg_1;
            fg2 = mkLiteral colors.fg_grey_2;
            fg3 = mkLiteral colors.bg_current_word;

            background-color = mkLiteral "transparent";
            text-color = mkLiteral "@fg0";

            margin = mkLiteral "0px";
            padding = mkLiteral "0px";
            spacing = mkLiteral "0px";
          };

          "window" = {
            location = mkLiteral "north";
            y-offset = mkLiteral "calc(50% - 176px)";
            width = 480;
            border-radius = mkLiteral "24px";

            background-color = mkLiteral "@bg0";
          };

          "mainbox" = {
            padding = mkLiteral "12px";
          };

          "inputbar" = {
            background-color = mkLiteral "@bg1";
            border-color = mkLiteral "@bg3";

            border = mkLiteral "2px";
            border-radius = mkLiteral "16px";

            padding = mkLiteral "8px 16px";
            spacing = mkLiteral "8px";
            children = mkLiteral "[ prompt, entry ]";
          };

          "prompt" = {
            text-color = mkLiteral "@fg2";
          };

          "entry" = {
            placeholder = "Search";
            placeholder-color = mkLiteral "@fg3";
          };

          "message" = {
            margin = mkLiteral "12px 0 0";
            border-radius = mkLiteral "16px";
            border-color = mkLiteral "@bg2";
            background-color = mkLiteral "@bg2";
          };

          "textbox" = {
            padding = mkLiteral "8px 24px";
          };

          "listview" = {
            background-color = mkLiteral "transparent";

            margin = mkLiteral "12px 0 0";
            lines = 8;
            columns = 1;

            fixed-height = false;
          };

          "element" = {
            padding = mkLiteral "8px 16px";
            spacing = mkLiteral "8px";
            border-radius = mkLiteral "16px";
          };

          "element normal active" = {
            text-color = mkLiteral "@bg3";
          };

          "element alternate active" = {
            text-color = mkLiteral "@bg3";
          };

          "element selected normal, element selected active" = {
            background-color = mkLiteral "@bg3";
            text-color = mkLiteral "@fg3";
          };

          "element-icon" = {
            size = mkLiteral "1em";
            vertical-align = mkLiteral "0.5";
          };

          "element-text" = {
            text-color = mkLiteral "inherit";
          };
        };
        rofiNetworkManager.colors = {
          enabled = colors.fg_green;
          disabled = colors.fg_red;
        };
      };
    };
    home = {
      locker.gtklock.gtkTheme = "Gruvbox-Dark";
      wm.hyprland = {
        colors = {
          general = {
            inactiveBorder      = (builtins.replaceStrings ["#"] ["0xff"] colors.bg_1 );
            activeBorder        = (builtins.replaceStrings ["#"] ["0xff"] colors.fg_orange );
            noGroupBorder       = (builtins.replaceStrings ["#"] ["0xff"] colors.bg_2 );
            noGroupAorderActive = (builtins.replaceStrings ["#"] ["0xff"] colors.fg_yellow );
          };
        };
      };
      pointerCursor = {
        enable = true;
        package = pkgs.capitaine-cursors-themed;
        name = "Capitaine Cursors (Gruvbox)";
        size = cfg.cursorSize;
        gtk.enable = true;
        hyprcursor = {
          enable = true;
          size = cfg.cursorSize;
        };
      };
    };

    programs.vscode.profiles = lib.mkIf config.gui.vscode.enable {
      default.extensions = with pkgs.vscode-extensions; [
        jdinhlife.gruvbox
      ];
    };

    gtk = {
      theme = {
        package = pkgs.gruvbox-gtk-theme;
        name = "Gruvbox-Dark";
      };
      cursorTheme = {
        package = pkgs.capitaine-cursors-themed;
        name = "Capitaine Cursors (Gruvbox)";
        size = cfg.cursorSize;
      };
    };
  };
}
