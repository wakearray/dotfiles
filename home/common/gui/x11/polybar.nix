{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  x11 = gui.x11;
  polybar = gui.polybar;
  i3 = gui.wm.i3;
in
{
  options.gui.polybar = with lib; {
    enable = mkEnableOption "Enable an opinionated Polybar config.";

    font-0 = mkOption {
      type = types.str;
      default = "SauceCodePro NFM:size=10;0";
      description = ''
      The font to use in the bar.
      Formatted as `<fontconfig pattern>;<int: vertical offset in pixels>`. The fontconfig pattern looks like: `<string: font name><string: options>` options are formatted like: `:size=<float: font size>` or `:style=Regular` or `:weight=Bold`
      More info can be found here: https://github.com/polybar/polybar/wiki/Fonts
      '';
    };

    colors = {
      foreground = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = "#d4be98";
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      background = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = "#141617";
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      time-foreground = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = polybar.colors.foreground;
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      time-background = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = polybar.colors.background;
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      urgent-foreground = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = "#ea6962";
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      urgent-background = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = polybar.colors.background;
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      focused-foreground = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = "#d8a657";
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      focused-background = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = polybar.colors.background;
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      unfocused-foreground = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = polybar.colors.foreground;
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      unfocused-background = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = polybar.colors.background;
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
      visible-underline = mkOption {
        type = types.strMatching "#[0-9A-Fa-f]{6}";
        default = polybar.colors.foreground;
        description = "A 6 digit hex color code beginning with a `#` in the standard format of #RRGGBB.";
      };
    };
  };
  config = lib.mkIf (gui.enable && (x11.enable && (i3.enable && polybar.enable))) {
    services.polybar = {
      enable = true;
      config = {
        # The top bar
        "bar/top" = {
          # i3 Specific
          override-redirect = false;
          wm-restack = "i3";
          scroll-up = "#i3.prev";
          scroll-down = "#i3.next";

          # Monitor Details
          #monitor = "Builtin Display";

          # Bar size/shape
          width = "100%";
          height = "3%";
          radius = 0;
          bottom = false;
          offset-x = 0;
          offset-y = 0;

          # Bar colors
          background = "${polybar.colors.background}";
          foreground = "${polybar.colors.foreground}";

          # Modules
          modules-right = "tray memory date";
          modules-left = "i3";

          font-0 = "SauceCodePro NFM:size=20;0";
        };

        "module/tray" = {
          type = "internal/tray";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 5;
          format = "<label>";
          label = "╭ 󰍛 %gb_used% ╮";
        };

        "module/date" = {
          type = "internal/date";
          interval = "20";
          date = "";
          time = "%l:%M %P";
          date-alt = "%a %b %d ";
          time-alt = "%l:%M %P";

          format = "╭ <label> ╮";
          format-foreground = "${polybar.colors.time-foreground}";
          format-background = "${polybar.colors.time-background}";

          label = "%date%󱑎 %time%";
          label-font = "1";
          label-foreground = "${polybar.colors.time-foreground}";
          label-background = "${polybar.colors.time-background}";
        };

        "module/i3" = {
          type = "internal/i3";
          show-urgent = true;

          # This will split the workspace name on ':'
          # Default: false
          #strip-wsnumbers = true;

          # Sort the workspaces by index instead of the default
          # sorting that groups the workspaces by output
          # Default: false
          #index-sort = true;

          # Set the scroll cycle direction
          # Default: true
          reverse-scroll = false;

          # Available tags:
          #   <label-state> (default) - gets replaced with <label-(focused|unfocused|visible|urgent)>
          #   <label-mode> (default)
          format = "<label-state> <label-mode>";

          # Available tokens:
          #   %mode%
          # Default: %mode%
          label-mode = "%mode%";
          label-mode-padding = 0;
          label-mode-foreground = "${polybar.colors.urgent-foreground}";
          label-mode-background = "${polybar.colors.urgent-background}";

          # Available tokens:
          #   %name%
          #   %icon%
          #   %index%
          #   %output%
          # Default: %icon% %name%
          label-focused = "╭ %name% ╮";
          label-focused-foreground = "${polybar.colors.focused-foreground}";
          label-focused-background = "${polybar.colors.background}";
          label-focused-padding = 0;

          # Available tokens:
          #   %name%
          #   %icon%
          #   %index%
          #   %output%
          # Default: %icon% %name%
          label-unfocused = "╭ %name% ╮";
          label-unfocused-foreground = "${polybar.colors.foreground}";
          label-unfocused-background = "${polybar.colors.background}";
          label-unfocused-padding = 0;

          # Available tokens:
          #   %name%
          #   %icon%
          #   %index%
          #   %output%
          # Default: %icon% %name%
          label-visible = "╭ %name% ╮";
          label-visible-underline = "${polybar.colors.background}";
          label-visible-padding = 0;

          # Available tokens:
          #   %name%
          #   %icon%
          #   %index%
          #   %output%
          # Default: %icon% %name%
          label-urgent = "╭ %name% ╮";
          label-urgent-foreground = "${polybar.colors.urgent-foreground}";
          label-urgent-background = "${polybar.colors.urgent-background}";
          label-urgent-padding = 0;

          # Separator in between workspaces
          label-separator = "";
          label-separator-padding = 0;
          label-separator-foreground = "${polybar.colors.background}";
        };
        settings = {
          screenchange-reload = true;
        };
      };
      script = "sh /home/kent/.config/i3/polybar.sh";
      package = pkgs.polybar.override {
        i3Support = true;
        mpdSupport = true;
        nlSupport = false;
        alsaSupport = false;
      };
    };

    home.file = {
      ".config/polybar/polybar.sh" = {
        enable = true;
        executable = true;
        force = true;
        text = ''
  #!/usr/bin/env sh

  # Terminate already running bar instances
  polybar-msg cmd quit
  wait 2
  sudo pkill polybar

  # Wait until the processes have been shut down
  while pgrep -x polybar >/dev/null; do sleep 1; done

  # Launch polybar
  polybar top &
        '';
      };
      ".config/polybar/quit_polybar.sh" = {
        enable = true;
        executable = true;
        force = true;
        text = ''
  #!/usr/bin/env sh

  # Terminate running bar instances
  polybar-msg cmd quit
  wait 2
  sudo pkill polybar
        '';
      };
    };
  };
}
