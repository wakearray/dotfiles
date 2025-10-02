{ lib, config, ... }:
let
  cfg = config.home.zellij;

  # Function to convert a single hex character to decimal
  hexCharToDecimal = c: builtins.elemAt [
    0 1 2 3 4 5 6 7 8 9
    10 11 12 13 14 15
  ] (builtins.elemIndex c "0123456789abcdef");

  # Function to convert a pair of hex characters to a decimal value
  hexPairToDecimal = pair: (hexCharToDecimal (builtins.elemAt pair 0)) * 16
                           + (hexCharToDecimal (builtins.elemAt pair 1));

  # Function to convert a full hex color string to the RRR GGG BBB format
  hexToRGB = hex: let
    # Remove the leading '#' if present
    cleanHex = if builtins.substring 0 1 hex == "#" then builtins.substring 1 6 hex else hex;
    r = hexPairToDecimal (builtins.substring 0 2 cleanHex);
    g = hexPairToDecimal (builtins.substring 2 2 cleanHex);
    b = hexPairToDecimal (builtins.substring 4 2 cleanHex);
  in "${toString r} ${toString g} ${toString b}";

  # Zellij currently supports this, with plans to retire it in the future.
  legacyThemeSubmodule = {
    options = with lib; {
      name = mkOption {
        type = types.strMatching "[a-zA-Z]+(?:_[a-zA-Z]+)*";
        default = "default";
        description = "Theme names should be in snake_case.";
      };
      fg = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "213 196 161";
        description = "";
      };
      bg = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "40 40 40";
        description = "";
      };
      black = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "60 56 54";
        description = "";
      };
      red = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "205 75 69";
        description = "";
      };
      green = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "152 151 26";
        description = "";
      };
      yellow = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "215 153 33";
        description = "";
      };
      blue = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "69 133 136";
        description = "";
      };
      magenta = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "177 98 134";
        description = "";
      };
      cyan = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "104 157 106";
        description = "";
      };
      white = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "251 241 199";
        description = "";
      };
      orange = mkOption {
        type = types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = "214 93 14";
        description = "";
      };
    };
  };

  # Current "flavor" based theme options
  themeSubmodule = {
    options = with lib; {
      base = mkOption {
        type = types.nullOr types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = null;
        description = "The base color of the component.";
      };
      background = mkOption {
        type = types.nullOr types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))";
        default = null;
        description = "The background color of the component.";
      };
      emphasis = mkOption {
        type = with types; nullOr addCheck (value:
            if builtins.length value <= 4 then
              true
            else
              throw "List can have at most 4 entries, but got ${builtins.length value}."
          ) (listOf (strMatching "((d{1,3}) (d{1,3}) (d{1,3}))"));
        default = null;
        description = "The color of text emphases inside the text. These are used either to differentiate whole text components one from another (with each having a full color of one of the emphases), or even combined in a single component (eg. when indicating indices in fuzzy find results). Not all of these are used in the base UI, but they might be used in user plugins.

*Note: This list is limited to 4 entries at most.*";
      };
    };
  };
in
{
  # zellij - A terminal workspace with batteries included
  # https://github.com/zellij-org/zellij

  options.home.zellij = with lib; {
    enable = mkEnableOption "Enable an Zellij configuration that's partially Nix integrated.";

    themes = {
      legacyTheme = {
        fg = mkOption {
          type = types.color;
          default = "#D5C4A1";
          description = "";
        };
        bg = mkOption {
          type = types.color;
          default = "#282828";
          description = "";
        };
        black = mkOption {
          type = types.color;
          default = "#3C3836";
          description = "";
        };
        red = mkOption {
          type = types.color;
          default = "#CD4B45";
          description = "";
        };
        green = mkOption {
          type = types.color;
          default = "#98971A";
          description = "";
        };
        yellow = mkOption {
          type = types.color;
          default = "#D79921";
          description = "";
        };
        blue = mkOption {
          type = types.color;
          default = "#458588";
          description = "";
        };
        magenta = mkOption {
          type = types.color;
          default = "#B16286";
          description = "";
        };
        cyan = mkOption {
          type = types.color;
          default = "#689D6A";
          description = "";
        };
        white = mkOption {
          type = types.color;
          default = "#FBF1C7";
          description = "";
        };
        orange = mkOption {
          type = types.color;
          default = "#D65D0E";
          description = "";
        };
      };
    };
    settings = {
      theme = {
        text_unselected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {
            base = "#D4BE98";
            background = "#282828";
          };
          description = "This component refers to the bare text parts of the Zellij UI (for example, the Ctrl or Alt modifier indications in the status-bar).";
        };
        text_selected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {
            base = "#282828";
            background = "#7DAEA3";
          };
          description = "This component refers to the bare text parts of the Zellij UI when they need to indicate selection (eg. when paging through search results). This is often done by providing them a different color background than their unselected counterparts.";
        };
        ribbon_unselected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {
            base = "#D4BE98";
            background = "#282828";
          };
          description = "Ribbons are used often in the Zellij UI, examples are the tabs and the keybinding modes in the status bar.";
        };
        ribbon_selected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {
            base = "#282828";
            background = "#A9B665";
          };
          description = "Selected ribbons are often indicated with a different color than their unselected counterparts (eg. the focused tab, or the active keybinding mode in the status bar).";
        };
        table_title = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "The table UI component has a different style applied to its title line than the rest of the table. This is what differentiates this line.";
        };
        table_cell_unselected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "The style of an unselected cell in a table. Cells can be specified as selected or unselected individually, but it is often the case that a full table line is specified to have selected or unselected cells.";
        };
        table_cell_selected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "Often differentiated from its unselected counterpart by changing its background color.";
        };
        list_unselected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "A line item in a nested list, it can be arbitrarily indented. Its indentation indication is not included in the item specification.";
        };
        list_selected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "Often differentiated from its unselected counterpart with a different background color.";
        };
        frame_selected = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "The frame around the focused pane.";
        };
        frame_highlight = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "This is the frame around the focused pane when the user enters a mode other than the base mode (eg. PANE or TAB mode).";
        };
        exit_code_success = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "The color of the exit code indication (here, only the base part of the specification is used, the rest are reserved for future use). These can be seen in command panes (eg. when using zellij run) after the command exited successfully.";
        };
        exit_code_error = mkOption {
          type = with types; nullOr (submodule themeSubmodule);
          default = {};
          description = "The color of the exit code indication (here, only the base part of the specification is used, the rest are reserved for future use). These can be seen in command panes (eg. when using zellij run) after the command exited with an error.";
        };
        multiplayer_user_colors = mkOption {
          type = types.listOf (types.strMatching "((d{1,3}) (d{1,3}) (d{1,3}))");
          default = [
            "225 0 225"
            "0 217 227"
            "225 230 0"
            "0 229 229"
            "225 53 94"
          ];
          description = "This is the only theme section that is different from the rest of the UI components and is defined thus:
```kdl
multiplayer_user_colors {
    player_1 255 0 255
    player_2 0 217 227
    player_3 0
    player_4 255 230 0
    player_5 0 229 229
    player_6 0
    player_7 255 53 94
    player_8 0
    player_9 0
    player_10 0
}
```
Each player represents the color given to a user joining (attaching) to an active session. These colors appear the same to all users and are given by order of attaching.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };

    # `zellij.settings` expects yaml, but zellij has used kdl for years now.
    # Use `home.file` to write the approriate configuration files manually.
    xdg.configFile = {
      "zellij/config.kdl" = {
        enable = true;
        forced = true;
        text = /*kdl*/ ''
keybinds {
  normal {
    // uncomment this and adjust key if using copy_on_select=false
    // bind "Alt c" { Copy; }
  }
  locked {
    bind "Ctrl g" { SwitchToMode "Normal"; }
  }
  resize {
    bind "Ctrl n" { SwitchToMode "Normal"; }
    bind "h" "Left" { Resize "Increase Left"; }
    bind "j" "Down" { Resize "Increase Down"; }
    bind "k" "Up" { Resize "Increase Up"; }
    bind "l" "Right" { Resize "Increase Right"; }
    bind "H" { Resize "Decrease Left"; }
    bind "J" { Resize "Decrease Down"; }
    bind "K" { Resize "Decrease Up"; }
    bind "L" { Resize "Decrease Right"; }
    bind "=" "+" { Resize "Increase"; }
    bind "-" { Resize "Decrease"; }
  }
  pane {
    bind "Ctrl p" { SwitchToMode "Normal"; }
    bind "h" "Left" { MoveFocus "Left"; }
    bind "l" "Right" { MoveFocus "Right"; }
    bind "j" "Down" { MoveFocus "Down"; }
    bind "k" "Up" { MoveFocus "Up"; }
    bind "p" { SwitchFocus; }
    bind "n" { NewPane; SwitchToMode "Normal"; }
    bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
    bind "r" { NewPane "Right"; SwitchToMode "Normal"; }
    bind "x" { CloseFocus; SwitchToMode "Normal"; }
    bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
    bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
    bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
    bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
    bind "c" { SwitchToMode "RenamePane"; PaneNameInput 0;}
  }
  move {
    bind "Ctrl h" { SwitchToMode "Normal"; }
    bind "n" "Tab" { MovePane; }
    bind "p" { MovePaneBackwards; }
    bind "h" "Left" { MovePane "Left"; }
    bind "j" "Down" { MovePane "Down"; }
    bind "k" "Up" { MovePane "Up"; }
    bind "l" "Right" { MovePane "Right"; }
  }
  tab {
    bind "Ctrl t" { SwitchToMode "Normal"; }
    bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
    bind "h" "Left" "Up" "k" { GoToPreviousTab; }
    bind "l" "Right" "Down" "j" { GoToNextTab; }
    bind "n" { NewTab; SwitchToMode "Normal"; }
    bind "x" { CloseTab; SwitchToMode "Normal"; }
    bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
    bind "b" { BreakPane; SwitchToMode "Normal"; }
    bind "]" { BreakPaneRight; SwitchToMode "Normal"; }
    bind "[" { BreakPaneLeft; SwitchToMode "Normal"; }
    bind "1" { GoToTab 1; SwitchToMode "Normal"; }
    bind "2" { GoToTab 2; SwitchToMode "Normal"; }
    bind "3" { GoToTab 3; SwitchToMode "Normal"; }
    bind "4" { GoToTab 4; SwitchToMode "Normal"; }
    bind "5" { GoToTab 5; SwitchToMode "Normal"; }
    bind "6" { GoToTab 6; SwitchToMode "Normal"; }
    bind "7" { GoToTab 7; SwitchToMode "Normal"; }
    bind "8" { GoToTab 8; SwitchToMode "Normal"; }
    bind "9" { GoToTab 9; SwitchToMode "Normal"; }
    bind "Tab" { ToggleTab; }
  }
  scroll {
    bind "Ctrl s" { SwitchToMode "Normal"; }
    bind "e" { EditScrollback; SwitchToMode "Normal"; }
    bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
    bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
    bind "j" "Down" { ScrollDown; }
    bind "k" "Up" { ScrollUp; }
    bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
    bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
    bind "d" { HalfPageScrollDown; }
    bind "u" { HalfPageScrollUp; }
    // uncomment this and adjust key if using copy_on_select=false
    // bind "Alt c" { Copy; }
  }
  search {
    bind "Ctrl s" { SwitchToMode "Normal"; }
    bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
    bind "j" "Down" { ScrollDown; }
    bind "k" "Up" { ScrollUp; }
    bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
    bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
    bind "d" { HalfPageScrollDown; }
    bind "u" { HalfPageScrollUp; }
    bind "n" { Search "down"; }
    bind "p" { Search "up"; }
    bind "c" { SearchToggleOption "CaseSensitivity"; }
    bind "w" { SearchToggleOption "Wrap"; }
    bind "o" { SearchToggleOption "WholeWord"; }
  }
  entersearch {
    bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
    bind "Enter" { SwitchToMode "Search"; }
  }
  renametab {
    bind "Ctrl c" { SwitchToMode "Normal"; }
    bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
  }
  renamepane {
    bind "Ctrl c" { SwitchToMode "Normal"; }
    bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
  }
  session {
    bind "Ctrl o" { SwitchToMode "Normal"; }
    bind "Ctrl s" { SwitchToMode "Scroll"; }
    bind "d" { Detach; }
    bind "w" {
      LaunchOrFocusPlugin "session-manager" {
        floating true
        move_to_focused_tab true
      };
      SwitchToMode "Normal"
    }
  }
  tmux {
    bind "[" { SwitchToMode "Scroll"; }
    bind "Ctrl b" { Write 2; SwitchToMode "Normal"; }
    bind "\"" { NewPane "Down"; SwitchToMode "Normal"; }
    bind "%" { NewPane "Right"; SwitchToMode "Normal"; }
    bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
    bind "c" { NewTab; SwitchToMode "Normal"; }
    bind "," { SwitchToMode "RenameTab"; }
    bind "p" { GoToPreviousTab; SwitchToMode "Normal"; }
    bind "n" { GoToNextTab; SwitchToMode "Normal"; }
    bind "Left" { MoveFocus "Left"; SwitchToMode "Normal"; }
    bind "Right" { MoveFocus "Right"; SwitchToMode "Normal"; }
    bind "Down" { MoveFocus "Down"; SwitchToMode "Normal"; }
    bind "Up" { MoveFocus "Up"; SwitchToMode "Normal"; }
    bind "h" { MoveFocus "Left"; SwitchToMode "Normal"; }
    bind "l" { MoveFocus "Right"; SwitchToMode "Normal"; }
    bind "j" { MoveFocus "Down"; SwitchToMode "Normal"; }
    bind "k" { MoveFocus "Up"; SwitchToMode "Normal"; }
    bind "o" { FocusNextPane; }
    bind "d" { Detach; }
    bind "Space" { NextSwapLayout; }
    bind "x" { CloseFocus; SwitchToMode "Normal"; }
  }
  shared_except "locked" {
    bind "Ctrl g" { SwitchToMode "Locked"; }
    bind "Ctrl q" { Quit; }
    bind "Alt n" { NewPane; }
    bind "Alt i" { MoveTab "Left"; }
    bind "Alt o" { MoveTab "Right"; }
    bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
    bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
    bind "Alt j" "Alt Down" { MoveFocus "Down"; }
    bind "Alt k" "Alt Up" { MoveFocus "Up"; }
    bind "Alt =" "Alt +" { Resize "Increase"; }
    bind "Alt -" { Resize "Decrease"; }
    bind "Alt [" { PreviousSwapLayout; }
    bind "Alt ]" { NextSwapLayout; }
  }
  shared_except "normal" "locked" {
    bind "Enter" "Esc" { SwitchToMode "Normal"; }
  }
  shared_except "pane" "locked" {
    bind "Ctrl p" { SwitchToMode "Pane"; }
  }
  shared_except "resize" "locked" {
    bind "Ctrl n" { SwitchToMode "Resize"; }
  }
  shared_except "scroll" "locked" {
    bind "Ctrl s" { SwitchToMode "Scroll"; }
  }
  shared_except "session" "locked" {
    bind "Ctrl o" { SwitchToMode "Session"; }
  }
  shared_except "tab" "locked" {
    bind "Ctrl t" { SwitchToMode "Tab"; }
  }
  shared_except "move" "locked" {
    bind "Ctrl h" { SwitchToMode "Move"; }
  }
  shared_except "tmux" "locked" {
    bind "Ctrl b" { SwitchToMode "Tmux"; }
  }
}

plugins {
  tab-bar location="zellij:tab-bar"
  status-bar location="zellij:status-bar"
  strider location="zellij:strider"
  compact-bar location="zellij:compact-bar"
  session-manager location="zellij:session-manager"
  welcome-screen location="zellij:session-manager" {
    welcome_screen true
  }
  filepicker location="zellij:strider" {
    cwd "/"
  }
}

//  Send a request for a simplified ui (without arrow fonts) to plugins
//  Options:
//    - true
//    - false (Default)
//
simplified_ui true

// Toggle between having pane frames around the panes
// Options:
//   - true (default)
//   - false
//
pane_frames false

// Define color themes for Zellij
// For more examples, see: https://github.com/zellij-org/zellij/tree/main/example/themes
// Once these themes are defined,
// one of them should to be selected in the "theme" section of this file
//
themes {
  default {
    fg ${hexToRGB cfg.themes.legacyTheme.fg}
    bg ${hexToRGB cfg.themes.legacyTheme.bg}
    black ${hexToRGB cfg.themes.legacyTheme.black}
    red ${hexToRGB cfg.themes.legacyTheme.red}
    green ${hexToRGB cfg.themes.legacyTheme.green}
    yellow ${hexToRGB cfg.themes.legacyTheme.yellow}
    blue ${hexToRGB cfg.themes.legacyTheme.blue}
    magenta ${hexToRGB cfg.themes.legacyTheme.magenta}
    cyan ${hexToRGB cfg.themes.legacyTheme.cyan}
    white ${hexToRGB cfg.themes.legacyTheme.white}
    orange ${hexToRGB cfg.themes.legacyTheme.orange}
  }
}

// Choose the theme that is specified in the themes section.
// Default: default
//
theme "default"

// Provide a command to execute when copying text. The text will be piped to
// the stdin of the program to perform the copy. This can be used with
// terminal emulators which do not support the OSC 52 ANSI control sequence
// that will be used by default if this option is not set.
// Examples:
//
// copy_command "xclip -selection clipboard" // x11
// copy_command "wl-copy"                    // wayland

// Choose the destination for copied text
// Allows using the primary selection buffer (on x11/wayland) instead of the system clipboard.
// Does not apply when using copy_command.
// Options:
//   - system (default)
//   - primary
//
// copy_clipboard "primary"

// Enable or disable automatic copy (and clear) of selection when releasing mouse
// Default: true
//
copy_on_select true

// Disable startup tips
show_startup_tips false
        '';
      };

      "zellij/layouts/default.kdl" = {
        enable = true;
        forced = true;
        text = /*kdl*/ ''
          layout {
            pane size=1 borderless=true {
              plugin location="tab-bar"
            }
            pane
            pane size=2 borderless=true {
              plugin location="status-bar"
            }
          }
        '';
      };

      "zellij/layouts/split.kdl" = {
        enable = true;
        forced = true;
        text = /*kdl*/ ''
          layout {
            pane size=1 borderless=true {
              plugin location="tab-bar"
            }
            pane
            pane
            pane size=2 borderless=true {
              plugin location="status-bar"
            }
          }
        '';
      };
    };
  };
}

