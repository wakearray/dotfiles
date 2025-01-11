{ lib, config, ... }:
let
  cfg = config.gui.eww;
  colors = cfg.bar.colors;
in
{
  config = lib.mkIf (cfg.enable && cfg.bar.enable) {
    home.file."/.config/eww/bar/eww.scss" = {
      enable = cfg.enable;
      force = true;
      text = /*scss*/ ''
  * {
    all: unset; // Unsets everything so you can style everything from scratch
  }

  // Global Styles
  .bar {
    //background       : rgba(255, 255, 255, 0.0); // only way to make the background invisible
    background-color : ${colors.bar-bg};
    color            : ${colors.bar-fg};
    border-radius    : 6px;
    padding-top      : 0px;
    padding-bottom   : 0px;
    padding-left     : 10px;
    padding-right    : 10px;
    margin-top       : 0px;
    margin-bottom    : 0px;
    margin-left      : 0px;
    margin-right     : 0px;
  }

  // Styles on classes (see eww.yuck for more information)

  .systray {
    margin-right     : 20px;
  }

  .tooltiptext {
    color            : ${colors.tooltip-fg};
    background-color : ${colors.tooltip-bg};
    border-radius    : 6px;
    margin           : 1em;
    padding          : 1em;
  }

  .icon {
    margin-left      : 0px;
    margin-right     : 10px;
  };

  .battery scale trough highlight {
    border-radius    : 10px;
  }

  .battery scale trough {
    border-radius    : 50px;
    min-height       : 5px;
    min-width        : 15px;
    margin-left      : 0px;
    margin-right     : 0px;
  }

  .battery-critical scale trough highlight {
    background-color : ${colors.metric-fg};
  }

  .battery-critical scale trough {
    background-color : ${colors.metric-bg};
  }

  .battery-low scale trough highlight {
    background-color : ${colors.metric-fg};
  }

  .battery-low scale trough {
    background-color : ${colors.metric-bg};
  }

  .battery-full scale trough highlight {
    background-color : ${colors.metric-fg};
  }

  .battery-full scale trough {
    background-color : ${colors.metric-bg};
  }

  .battery-charging scale trough highlight {
    background-color : ${colors.metric-fg};
  }

  .battery-charging scale trough {
    background-color : ${colors.metric-bg};
  }

  .battery-discharging scale trough highlight {
    background-color : ${colors.metric-fg};
  }

  .battery-discharging scale trough {
    background-color : ${colors.metric-bg};
  }

  .metric:hover {

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
