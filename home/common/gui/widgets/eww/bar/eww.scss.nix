{ lib, config, ... }:
let
  gui = config.gui;
  eww = gui.eww;
  bar = eww.bar;
  colors = bar.colors;
  iconColors = eww.icons.colors;
in
{
  config = lib.mkIf (eww.enable && bar.enable)  {
    home.file."/.config/eww/bar/eww.scss" = {
      enable = true;
      force = true;
      text = /*scss*/ ''
  * {
    all: unset; // Unsets everything so you can style everything from scratch
  }

  // Global Styles
  .bar {
    background       : rgba(255, 255, 255, 0.0); // only way to make the background invisible
    padding-top      : 0px;
    padding-bottom   : 0px;
    padding-left     : 0px;
    padding-right    : 0px;
    margin-top       : 0px;
    margin-bottom    : 0px;
    margin-left      : 0px;
    margin-right     : 0px;
  }

  // Styles on classes (see eww.yuck for more information)

  .barwidget {
    background-color : ${colors.bar-bg};
    color            : ${colors.text};
    border-radius    : 6px;
    padding-top      : 0px;
    padding-bottom   : 0px;
    padding-left     : 10px;
    padding-right    : 10px;
    margin-top       : 0px;
    margin-bottom    : 0px;
    margin-left      : 12px;
    margin-right     : 12px;
  }

  // GTK Tooltip Styling
  tooltip label {
    color            : ${colors.tooltip-fg};
    padding          : 0.3em 0.6em;
  }

  tooltip.background {
    border-radius    : 6px;
    background-color : ${colors.tooltip-bg};
  }

  // GTK System Tray Styling
  // https://github.com/elkowar/eww/issues/1067
  .systray {
    margin-right     : 20px;
  }

  .systray menu {
    border-radius    : 6px;
    padding          : 0.3em 0.6em;

    background-color : ${colors.tooltip-bg};

    separator {
      background-color : ${colors.tooltip-bg};
      padding-top    : 1px;

      &:last-child {
        padding      : unset;
      }
    }
  }

  // Eww Tooltip Styling
  .tooltiptext {
    color            : ${colors.tooltip-fg};
    background-color : ${colors.tooltip-bg};
    border-radius    : 6px;
    padding          : 0.3em 0.6em;
  }

  .icon {
    margin-left      : 0px;
    margin-right     : 10px;
  };

  .battery-charging {
    color : ${iconColors.battery-charging};
    margin-left      : 0px;
    margin-right     : 5px;
  }

  .battery-critical {
    color : ${iconColors.battery-critical};
    margin-left      : 0px;
    margin-right     : 5px;
  }

  .battery-discharging {
    color : ${iconColors.battery-discharging};
    margin-left      : 0px;
    margin-right     : 5px;
  }

  .battery-low {
    color : ${iconColors.battery-low};
    margin-left      : 0px;
    margin-right     : 5px;
  }

  .battery-full {
    color : ${iconColors.battery-full};
    margin-left      : 0px;
    margin-right     : 5px;
  }

  .metric scale trough highlight {
    background-color : ${colors.metric-fg};
    border-radius    : 10px;
  }

  .metric scale trough {
    background-color : ${colors.metric-bg};
    border-radius    : 50px;
    min-height       : 3px;
    min-width        : 50px;
    margin-left      : 0px;
    margin-right     : 10px;
  }

  .music {
    margin-left      : 50px;
    margin-right     : 50px;
  }

  .workspaces {
    margin-left      : 2px;
    margin-right     : 2px;
    margin-bottom    : 0.5em;
    margin-top       : 0.5em;
    padding          : 0px;
  }

  .workspace-active:hover {
    background-color : ${colors.workspace-active};
    border-width     : 0em;
  }

  .workspace-inactive:hover {
    background-color : ${colors.workspace-inactive};
    border-width     : 0em;
  }

  // 
  .workspace-active {
    min-height       : 1em;
    min-width        : 1em;
    border-style     : solid;
    background-color : ${colors.workspace-active};
    border-radius    : 50%;
  }
  // 
  .workspace-inactive {
    min-height      : 1em;
    min-width       : 1em;
    border-style    : solid;
    border-color    : ${colors.workspace-inactive};
    border-width    : 0.1em;
    background      : rgba(255, 255, 255, 0.0);
    border-radius   : 50%;
  }
      '';
    };
  };
}
