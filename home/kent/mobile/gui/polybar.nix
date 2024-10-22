{ ... }:
{
  services.polybar = {
    enable = true;
    config = {
      #
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
        label = "RAM %gb_used%/%gb_free%";

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
        # New in version 3.6.0
        label-warn = "RAM %gb_used%/%gb_free%";

        # Only applies if <bar-used> is used
        bar-used-indicator = "";
        bar-used-width = 50;
        bar-used-foreground-0 = "#55aa55";
        bar-used-foreground-1 = "#557755";
        bar-used-foreground-2 = "#f5a70a";
        bar-used-foreground-3 = "#ff5555";
        bar-used-fill = "▐";
        bar-used-empty = "▐";
        bar-used-empty-foreground = "#444444";

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
        type = "internal/date";
        interval = 5;
        date = "%m.%d";
        time = "%l:%M";

        # Available tags:
        #   <label> (default)
        format = "🕓 <label>";
        format-background = "#000";
        format-foreground = "#fff";

        # Available tokens:
        #   %date%
        #   %time%
        # Default: %date%
        label = "%date% %time%";
        label-font = 1;
        label-foreground = "#9A32DB";
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
        strip-wsnumbers = true;

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
        ws-icon-0 = "1;";
        ws-icon-1 = "2;";
        ws-icon-2 = "3;";
        ws-icon-3 = "4;󰈹";
        ws-icon-4 = "5;󰈹";
        ws-icon-5 = "10;";
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
        label-mode-background = "#e60053";

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-focused = "%index%";
        label-focused-foreground = "#ffffff";
        label-focused-background = "#3f3f3f";
        label-focused-underline = "#fba922";
        label-focused-padding = 4;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-unfocused = "%index%";
        label-unfocused-padding = 4;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-visible = "%index%";
        label-visible-underline = "#555555";
        label-visible-padding = 4;

        # Available tokens:
        #   %name%
        #   %icon%
        #   %index%
        #   %output%
        # Default: %icon% %name%
        label-urgent = "%index%";
        label-urgent-foreground = "#000000";
        label-urgent-background = "#bd2c40";
        label-urgent-padding = 4;

        # Separator in between workspaces
        label-separator = "|";
        label-separator-padding = 2;
        label-separator-foreground = "#ffb52a";
      };
      settings = {
        screenchange-reload = true;
      };
    };
    script = "sh /home/kent/.config/i3/polybar.sh";
  };

  home.file.".config/i3/polybar.sh" = {
    enable = true;
    executable = true;
    text = ''
#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar top &
    '';
  };
}
