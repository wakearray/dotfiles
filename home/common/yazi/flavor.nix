{ lib, config, ... }:
let
  yazi = config.gui.yazi;
  dark = yazi.flavor.dark;
  light = yazi.flavor.light;
  predefinedColors = [
    "reset" "black" "white" "red" "lightred"
    "green" "lightgreen" "yellow" "lightyellow"
    "blue" "lightblue" "magenta" "lightmagenta"
    "cyan" "lightcyan" "gray" "darkgray"
  ];

  # Submodule definition for a style
  styleSubmodule = {
    options = with lib; {
      # Foreground and background colors can be a hex string or one of the predefined colors
      fg = mkOption {
        type = with types; nullOr either (strMatching "^#[0-9a-fA-F]{6}$") (enum predefinedColors);
        default = "reset";
        description = "Foreground color";
      };

      bg = mkOption {
        type = with types; nullOr either (strMatching "^#[0-9a-fA-F]{6}$") (enum predefinedColors);
        default = "reset";
        description = "Background color";
      };

      # Boolean options for text attributes
      bold = mkEnableOption "Bold";
      dim = mkEnableOption "Dim (not supported by all terminals)";
      italic = mkEnableOption "Italic";
      underline = mkEnableOption "Underline";
      blink = mkEnableOption "Blink";
      blinkRapid = mkEnableOption "Rapid blink";
      reversed = mkEnableOption "Reversed foreground and background colors";
      hidden = mkEnableOption "Hidden";
      crossed = mkEnableOption "Crossed out";
    };
  };
in
{
  # yazi configurable flavor
  # https://yazi-rs.github.io/docs/configuration/theme
  # Settings for the flavor theme options are the same as themes:
  # https://yazi-rs.github.io/docs/configuration/theme

  # This nix file exposes every option supported by yazi flavor/themes
  # allowing you to fully configure your yazi flavors in nix.
  #
  # Requires home-manager for the `xdg.configFile` function.

  options.gui.yazi = with lib; {
    flavor = {
      dark = {
        enable = mkEnableOption "Enable the dark flavor config.";

        name = mkoption {
          type = with types; listOf str;
          default = "gruvbox-material-soft-dark";
          description = "Name of the desired theme in kebab-case.";
        };

        colors = {
          manager = {
            cwd = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = { fg = "#83a598"; };
              description = "Current working directory text style.";
            };
            hovered = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = { fg = ""; };
              description = "Hovered file style.";
            };
            previewHovered = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Hovered file style, in the preview pane.";
            };
            findKeyword = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of the highlighted portion in the filename.";
            };
            findPosition = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of current file location in all found files to the right of the filename.";
            };
            markerCopied = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Copied file marker style.";
            };
            markerCut = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Cut file marker style.";
            };
            markerMarked = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Marker style of pre-selected file in visual mode.";
            };
            markerSelected = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Selected file marker style.";
            };
            tabActive = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Active tab style.";
            };
            tabInactive = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Inactive tab style.";
            };
            tabWidth = mkOption {
              type = types.int;
              default = 1;
              description = "Tab maximum width. When set to a value greater than 2, the remaining space will be filled with the tab name, which is current directory name.";
            };
            countCopied = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of copied file number.";
            };
            countCut = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of cut file number.";
            };
            countSelected = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of selected file number.";
            };
            borderSymbol = mkOption {
              type = types.str;
              default = "│";
              description = "";
            };
            borderStyle = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Border style.";
            };
            syntectTheme = mkOption {
              type = types.str;
              default = "";
              description = "For example, \"~/Downloads/Dracula.tmTheme\", not available after using a flavor, as flavors always use their own tmTheme files tmtheme.xml.

            Code preview highlighting themes, which are paths to .tmTheme files. You can find them on GitHub using \"tmTheme\" as a keyword.";
            };
          };
          mode = {
            normalMain = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Normal mode main style.";
            };
            normalAlt = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Normal mode alternative style.";
            };
            selectMain = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Select mode main style.";
            };
            selectAlt = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Select mode alternative style.";
            };
            unsetMain = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Unset mode main style.";
            };
            unsetAlt = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Unset mode alternative style.";
            };
          };
          status = let
            seperatorSubmodule = {
                options = with lib; {
                  open = mkOption {
                    type = types.str;
                    default = "";
                    description = "";
                  };
                  close = mkOption {
                    type = types.str;
                    default = "";
                    description = "";
                  };
                };
              };
          in {
            overall = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Overall status bar style.";
            };
            sepLeft = mkOption {
              type = types.attrsOf (types.submodule seperatorSubmodule);
              default = { open = ""; close = ""; };
              description = "Left separator symbol. e.g. { open = \"\", close = \"]\" }.";
            };
            sepRight = mkOption {
              type = types.attrsOf (types.submodule seperatorSubmodule);
              default = { open = ""; close = ""; };
              description = "Right separator symbol. e.g. { open = \"[\", close = \"\" }.";
            };
            permType = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "File type.";
            };
            permRead = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Read permission.";
            };
            permWrite = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Write permission.";
            };
            permExec = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Execute permission.";
            };
            permSep = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "- separator.";
            };
            progressLabel = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Progress label style.";
            };
            progressNormal = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of the progress bar when it is not in an error state.";
            };
            progressError = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of the progress bar when an error occurs.";
            };
          };
          which = {
            cols = mkOption {
              type = types.nullOr types.int;
              default = 3;
              description = "Number of columns. The value can be 1, 2, 3.";
            };
            mask = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Mask style.";
            };
            cand = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Candidate key style.";
            };
            rest = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Rest key style.";
            };
            desc = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Description style.";
            };
            separator = mkOption {
              type = types.str;
              default = "  ";
              description = "";
            };
            separatorStyle = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Separator style.";
            };
          };
          confirm = {
            border = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Border style.";
            };
            title = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Title style.";
            };
            content = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Content style.";
            };
            list = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "List style, which is the style of the list of items below the content.";
            };
            btnYes = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "The style of the yes button.";
            };
            btnNo = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "The style of the no button.";
            };
            btnLabels = {
              buttonYes = mkOption {
                type = types.str;
                default = "[Y]es";
                description = "The label for the yes button.";
              };
              buttonNo = mkOption {
                type = types.str;
                default = "[N]o";
                description = "The label for the no button.";
              };
            };
          };
          spot = {
            border = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Border style.";
            };
            title = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Title style.";
            };
            tblCol = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "The style of the selected column in the table.";
            };
            tblCell = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "The style of the selected cell in the table.";
            };
          };
          notify = {
            titleInfo = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of the info title.";
            };
            titleWarn = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of the warning title.";
            };
            titleError = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Style of the error title.";
            };
          };
          pick = {
            border = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Border style.";
            };
            active = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Selected item style.";
            };
            inactive = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Unselected item style.";
            };
          };
          input = {
            border = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Border style.";
            };
            title = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Title style.";
            };
            value = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Value style.";
            };
            selected = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Selected value style.";
            };
          };
          cmp = {
            border = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Border style.";
            };
            active = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Selected item style.";
            };
            inactive = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Unselected item style.";
            };
            iconFile = mkOption {
              type = types.str;
              default = "";
              description = "File icon.";
            };
            iconFolder = mkOption {
              type = types.str;
              default = "";
              description = "Folder icon.";
            };
            iconCommand = mkOption {
              type = types.str;
              default = "";
              description = "Command icon.";
            };
          };
          tasks = {
            border = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Border style.";
            };
            title = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Title style.";
            };
            hovered = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Hovered item style.";
            };
          };
          help = {
            on = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Key column style.";
            };
            run = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Command column style.";
            };
            desc = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Description column style.";
            };
            hovered = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Hovered item style.";
            };
            footer = mkOption {
              type = types.attrsOf (types.submodule styleSubmodule);
              default = {};
              description = "Footer style.";
            };

            iconInfo = mkOption {
              type = types.str;
              default = "";
              description = "Info icon.";
            };
            iconWarn = mkOption {
              type = types.str;
              default = "";
              description = "Warning icon.";
            };
            iconError = mkOption {
              type = types.str;
              default = "";
              description = "Error icon.";
            };
          };
          filetype = {
            rules = mkOption {
              type = types.listOf (types.attrsOf types.str);
              default = [
                # Images
                { mime = "image/*"; fg = "#d3869b"; }

                # Media
                { mime = "{audio,video}/*"; fg = "#fabd2f"; }

                # Archives
                { mime = "application/*zip"; fg = "#fb4934"; }
                { mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}"; fg = "#fb4934"; }

                # Documents
                { mime = "application/{pdf,doc,rtf,vnd.*}"; fg = "#689d6a"; }

                # Fallback
                { name = "*"; fg = "#ebdbb2"; }
                { name = "*/"; fg = "#83a598"; }
              ];
              description = "Determine the color of files based on mimetype or name";
            };
          };
        };
      };

      light = {
        enable = mkEnableOption "Enable the light flavor config.";

        name = mkoption {
          type = with types; listOf str;
          default = "gruvbox-material-soft-light";
          description = "Name of the desired theme in kebab-case.";
        };
      };
    };
  };

  config = {
    xdg.configFile = {
        "yazi/theme.toml" = {
          enable = true;
          force = true;
          text = /* toml */ ''
[flavor]
dark=${dark.name}
light=${light.name}
          '';
        };

        "yazi/flavors/${dark.name}/flavor.toml" = {
          enable = true;
          force = true;
          text = /* toml */ ''
# vim:fileencoding=utf-8:foldmethod=marker

# : Manager {{{

[manager]
cwd = { fg = "#83a598" }

# Hovered
hovered = { reversed = true, bold = true }
# hovered         = { bg = "#3c3836", bold = true }
preview_hovered = { underline = true }

# Find
find_keyword = { fg = "#b8bb26", italic = true }
find_position = { fg = "#fe8019", bg = "reset", italic = true }

# Marker
marker_copied = { fg = "#8ec07c", bg = "#8ec07c" }
marker_cut = { fg = "#d3869b", bg = "#d3869b" }
marker_marked = { fg = "#83a598", bg = "#83a598" }
marker_selected = { fg = "#fbf1c7", bg = "#fbf1c7" }

# Tab
tab_active = { fg = "#282828", bg = "#a89984" }
tab_inactive = { fg = "#a89984", bg = "#504945" }
tab_width = 1

# Count
count_copied = { fg = "#282828", bg = "#8ec07c" }
count_cut = { fg = "#282828", bg = "#d3869b" }
count_selected = { fg = "#282828", bg = "#fbf1c7" }

# Border
border_symbol = "│"
border_style = { fg = "#665c54" }

# : }}}

# : Mode {{{

[mode]
normal_main = { fg = "#282828", bg = "#a89984", bold = true }
normal_alt = { fg = "#a89984", bg = "#504945" }
select_main = { fg = "#282828", bg = "#fe8019", bold = true }
select_alt = { fg = "#a89984", bg = "#504945" }
unset_main = { fg = "#282828", bg = "#b8bb26", bold = true }
unset_alt = { fg = "#a89984", bg = "#504945" }

# : }}}

# : Status {{{

[status]
sep_left = { open = "\ue0be", close = "\ue0b8" }
sep_right = { open = "\ue0be", close = "\ue0b8" }
overall = { }

# Progress
progress_label = { fg = "#ebdbb2", bold = true }
progress_normal = { fg = "#504945", bg = "#3c3836" }
progress_error = { fg = "#fb4934", bg = "#3c3836" }

# Permissions
perm_type = { fg = "#504945" }
perm_read = { fg = "#b8bb26" }
perm_write = { fg = "#fb4934" }
perm_exec = { fg = "#b8bb26" }
perm_sep = { fg = "#665c54" }

# : }}}

# : Select {{{

[pick]
border = { fg = "#458588" }
active = { fg = "#d3869b", bold = true }
inactive = {}

# : }}}

# : Input {{{

[input]
border = { fg = "#ebdbb2" }
title = {}
value = {}
selected = { reversed = true }

# : }}}

# : Tasks {{{

[tasks]
border = { fg = "#504945" }
title = {}
hovered = { underline = true }

# : }}}

# : Which {{{

[which]
mask = { bg = "#3c3836" }
cand = { fg = "#83a598" }
rest = { fg = "#928374" }
desc = { fg = "#fe8019" }
separator = "  "
separator_style = { fg = "#504945" }

# : }}}

# : Help {{{

[help]
on = { fg = "#83a598" }
run = { fg = "#d3869b" }
hovered = { reversed = true, bold = true }
footer = { fg = "#3c3836", bg = "#a89984" }

# : }}}

# : Notify {{{

[notify]
title_info = { fg = "#8ec07c" }
title_warn = { fg = "#fbf1c7" }
title_error = { fg = "#d3869b" }

# : }}}

# : File-specific styles {{{

[filetype]
rules = [
  # Images
  { mime = "image/*", fg = "#d3869b" },

  # Media
  { mime = "{audio,video}/*", fg = "#fabd2f" },

  # Archives
  { mime = "application/*zip", fg = "#fb4934" },
  { mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", fg = "#fb4934" },

  # Documents
  { mime = "application/{pdf,doc,rtf,vnd.*}", fg = "#689d6a" },

  # Fallback
  { name = "*", fg = "#ebdbb2" },
  { name = "*/", fg = "#83a598" },
]

# : }}}
        '';
      };
    };
  };
}

