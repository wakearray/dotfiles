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
        override-redirect = true;
        wm-restack = "i3";
        scroll-up = "#i3.prev";
        scroll-down = "#i3.next";

        # Bar size/shape
        width = "100%";
        height = "3%";
        radius = 0;
        bottom = false;
        dock = false;
        offset-x = 0;
        offset-y = 0;

        # Bar colors
        background = "\${colors.bg_dim}";
        foreground = "\${colors.fg0}";

        # Modules
        modules-right = "tray memory date";
        modules-center = "";
        modules-left = "i3";

        font-0 = "SauceCodePro NFM:size=20;0";
      };

      "module/tray" = {
        type = "internal/tray";
      };

      "module/memory" = {
        type = "internal/memory";

        # Seconds to sleep between updates
        # Default: 1
        interval = 3;

        # Default: 90
        # New in version 3.6.0
        warn-percentage = 95;

        # Available tags:
        #   <label> (default)
        #   <bar-used>
        #   <bar-free>
        #   <ramp-used>
        #   <ramp-free>
        #   <bar-swap-used>
        #   <bar-swap-free>
        #   <ramp-swap-used>
        #   <ramp-swap-free>
        format = "<label>";

        # Format used when RAM reaches warn-percentage
        # If not defined, format is used instead.
        # Available tags:
        #   <label-warn>
        #   <bar-used>
        #   <bar-free>
        #   <ramp-used>
        #   <ramp-free>
        #   <bar-swap-used>
        #   <bar-swap-free>
        #   <ramp-swap-used>
        #   <ramp-swap-free>
        # New in version 3.6.0
        #format-warn = <label-warn>;

        # Available tokens:
        #   %percentage_used% (default)
        #   %percentage_free%
        #   %used% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %free% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %total% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %gb_used%
        #   %gb_free%
        #   %gb_total%
        #   %mb_used%
        #   %mb_free%
        #   %mb_total%
        #   %percentage_swap_used%
        #   %percentage_swap_free%
        #   %swap_total% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %swap_free% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %swap_used% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %gb_swap_total%
        #   %gb_swap_free%
        #   %gb_swap_used%
        #   %mb_swap_total%
        #   %mb_swap_free%
        #   %mb_swap_used%
        label = "╭ RAM %gb_used%/%gb_free% ╮";

        # Available tokens:
        #   %percentage_used% (default)
        #   %percentage_free%
        #   %used% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %free% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %total% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %gb_used%
        #   %gb_free%
        #   %gb_total%
        #   %mb_used%
        #   %mb_free%
        #   %mb_total
        #   %percentage_swap_used%
        #   %percentage_swap_free%
        #   %swap_total% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %swap_free% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %swap_used% (Switches between KiB, MiB, and GiB) (New in version 3.6.0)
        #   %gb_swap_total%
        #   %gb_swap_free%
        #   %gb_swap_used%
        #   %mb_swap_total%
        #   %mb_swap_free%
        #   %mb_swap_used%
        # New in version 3.6.0
        label-warn = "RAM %gb_used%/%gb_free%";

        # Only applies if <bar-used> is used
        bar-used-indicator = "";
        bar-used-width = 50;
        bar-used-foreground-0 = "\${colors.green}";
        bar-used-foreground-1 = "\${colors.yellow}";
        bar-used-foreground-2 = "\${colors.orange}";
        bar-used-foreground-3 = "\${colors.red}";
        bar-used-fill = "▐";
        bar-used-empty = "▐";
        bar-used-empty-foreground = "\${colors.bg2}";

        # Only applies if <ramp-used> is used
        ramp-used-0 = "▁";
        ramp-used-1 = "▂";
        ramp-used-2 = "▃";
        ramp-used-3 = "▄";
        ramp-used-4 = "▅";
        ramp-used-5 = "▆";
        ramp-used-6 = "▇";
        ramp-used-7 = "█";

        # Only applies if <ramp-free> is used
        ramp-free-0 = "▁";
        ramp-free-1 = "▂";
        ramp-free-2 = "▃";
        ramp-free-3 = "▄";
        ramp-free-4 = "▅";
        ramp-free-5 = "▆";
        ramp-free-6 = "▇";
        ramp-free-7 = "█";
      };
      "module/date" = {
        type = "custom/script";
        exec = "/home/kent/.config/i3/date.sh";
        tail = true;
        click-left = "kill -USR1 %pid%";
        format = "╭ 󱑎<label> ╮";
        format-background = "\${colors.bg_dim}";
        format-foreground = "\${colors.fg0}";
      };

      "module/i3" = {
        type = "internal/i3";

        # Only show workspaces defined on the same output as the bar
        #
        # Useful if you want to show monitor specific workspaces
        # on different bars
        #
        # Default: false
        #pin-workspaces = true;

        # Show urgent workspaces regardless of whether the workspace is actually hidden
        # by pin-workspaces.
        #
        # Default: false
        # New in version 3.6.0
        show-urgent = true;

        # This will split the workspace name on ':'
        # Default: false
        #strip-wsnumbers = true;

        # Sort the workspaces by index instead of the default
        # sorting that groups the workspaces by output
        # Default: false
        #index-sort = true;

        # Create click handler used to focus workspace
        # Default: true
        #enable-click = false;

        # Create scroll handlers used to cycle workspaces
        # Default: true
        #enable-scroll = false;

        # Wrap around when reaching the first/last workspace
        # Default: true
        #wrapping-scroll = false;

        # Set the scroll cycle direction
        # Default: true
        reverse-scroll = false;

        # Use fuzzy (partial) matching for wc-icon.
        # Example: code;♚ will apply the icon to all workspaces
        # containing 'code' in the name
        # Changed in version 3.7.0: Selects longest string match instead of the first match.
        # Default: false
        #fuzzy-match = true;

        # ws-icon-[0-9]+ = <label>;<icon>
        # NOTE: The <label> needs to match the name of the i3 workspace
        # Neither <label> nor <icon> can contain a semicolon (;)
        ws-icon-0 = "1: Alacritty;";
        ws-icon-1 = "2: Discord;";
        ws-icon-2 = "3: Youtube;";
        ws-icon-3 = "4: Firefox;󰈹";
        ws-icon-4 = "5: Firefox;󰈹";
        ws-icon-5 = "6: Firefox;󰈹";
        ws-icon-6 = "7: Firefox;󰈹";
        ws-icon-7 = "8: Firefox;󰈹";
        ws-icon-8 = "9: Firefox;󰈹";
        ws-icon-9 = "10: Tidal;";
        ws-icon-default = "󰈹";
        # NOTE: You cannot skip icons, e.g. to get a ws-icon-6
        # you must also define a ws-icon-5.
        # NOTE: Icon will be available as the %icon% token inside label-*

        # Available tags:
        #   <label-state> (default) - gets replaced with <label-(focused|unfocused|visible|urgent)>
        #   <label-mode> (default)
        format = "<label-state> <label-mode>";

        # Available tokens:
        #   %mode%
        # Default: %mode%
        label-mode = "%mode%";
        label-mode-padding = 2;
        label-mode-foreground = "\${colors.red}";

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-focused = "╭ %index% ╷ %icon% ╷ %name% ╮";
        label-focused-foreground = "\${colors.yellow}";
        label-focused-background = "\${colors.bg_dim}";
        label-focused-underline = "#";
        label-focused-padding = 1;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-unfocused = "╭ %index% ╷ %icon% ╮";
        label-unfocused-foreground = "\${colors.fg0}";
        label-unfocused-padding = 1;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-visible = "╭ %index% ╷ %icon% ╮";
        label-visible-underline = "\${colors.bg_dim}";
        label-visible-padding = 1;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-urgent = "╭ %index% ╷ %icon% ╷ %name% ╮";
        label-urgent-foreground = "\${colors.red}";
        label-urgent-background = "\${colors.bg_dim}";
        label-urgent-padding = 1;

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
pkill polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar top &
      '';
    };
    # Date Module Script
    ".config/i3/date.sh" = {
      text = ''
#!/usr/bin/env sh

while true; do
    time=''$(TZ="America/New_York" date +'%l:%M %p')
    echo "╭ 󱑎''$time ╮"
  sleep 30 &
  wait
done
      '';
    };
  };
}
