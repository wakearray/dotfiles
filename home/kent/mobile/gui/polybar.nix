{ pkgs, ... }:
{
  services.polybar = {
    enable = true;
    config = {
      "colors" = {
        bg_dim = "#141617";
        bg0 = "#1d2021";
        bg1 = "#282828";
        bg2 = "#282828";
        bg3 = "#3c3836";
        bg4 = "#3c3836";
        bg5 = "#504945";
        bg_statusline1 = "#282828";
        bg_statusline2 = "#32302f";
        bg_statusline3 = "#504945";
        bg_diff_green = "#32361a";
        bg_visual_green = "#333e34";
        bg_diff_red = "#3c1f1e";
        bg_visual_red = "#442e2d";
        bg_diff_blue = "#0d3138";
        bg_visual_blue = "#2e3b3b";
        bg_visual_yellow = "#473c29";
        bg_current_word = "#32302f";
        fg0 = "#d4be98";
        fg1 = "#ddc7a1";
        red = "#ea6962";
        orange = "#e78a4e";
        yellow = "#d8a657";
        green = "#a9b665";
        aqua = "#89b482";
        blue = "#7daea3";
        purple = "#d3869b";
        bg_red = "#ea6962";
        bg_green = "#a9b665";
        bg_yellow = "#d8a657";
        grey0 = "#7c6f64";
        grey1 = "#928374";
        grey2 = "#a89984";
      };
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
        background = "\${colors.bg_dim}";
        foreground = "\${colors.fg0}";

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
        date-alt = "%a %b %d";
        time-alt = "%l:%M %P";

        format = "╭ <label> ╮";
        format-background = "\${colors.bg_dim}";
        format-foreground = "\${colors.fg0}";

        label = "%date% 󱑎 %time%";
        label-font = "1";
        label-foreground = "\${colors.fg0}";
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
        label-mode-foreground = "\${colors.red}";

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-focused = "╭ %name% ╮";
        label-focused-foreground = "\${colors.yellow}";
        label-focused-background = "\${colors.bg_dim}";
        label-focused-padding = 0;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-unfocused = "╭ %name% ╮";
        label-unfocused-foreground = "\${colors.fg0}";
        label-unfocused-padding = 0;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-visible = "╭ %name% ╮";
        label-visible-underline = "\${colors.bg_dim}";
        label-visible-padding = 0;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-urgent = "╭ %name% ╮";
        label-urgent-foreground = "\${colors.red}";
        label-urgent-background = "\${colors.bg_dim}";
        label-urgent-padding = 0;

        # Separator in between workspaces
        label-separator = "";
        label-separator-padding = 0;
        label-separator-foreground = "\${colors.bg_dim}";
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
    ".config/i3/polybar.sh" = {
      enable = true;
      executable = true;
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
  };
}
