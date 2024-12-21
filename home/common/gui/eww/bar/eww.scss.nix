{ lib, config, ... }:
let
  cfg = config.gui.eww;
  colors = cfg.bar.colors;
in
{
  config = lib.mkIf (cfg.enable && cfg.bar.enable) {
    home.file."/.config/eww/eww.scss" = {
      enable = cfg.enable;
      force = true;
      text = ''
  * {
    all: unset; // Unsets everything so you can style everything from scratch
  }

  // Global Styles
  .bar {
    background: rgba(255, 255, 255, 0.0);
    padding-top: 0px;
    padding-bottom: 0px;
    padding-left: 10px;
    padding-right: 10px;
    margin-top: 0px;
    margin-bottom: 0px;
    margin-left: 10px;
    margin-right: 10px;
  }

  // Styles on classes (see eww.yuck for more information)

  .metric scale trough highlight {
    background-color: ${colors.accent-1};
    border-radius: 10px;
  }

  .metric scale trough {
    background-color: ${colors.bg-2};
    border-radius: 50px;
    min-height: 3px;
    min-width: 50px;
    margin-left: 10px;
    margin-right: 20px;
  }

  .music {
    margin-left: 50px;
    margin-right: 50px;
  }

  .icon {
    color: ${colors.accent-1};
  }

  .workspaces {
    margin: 2px;
    padding: 0px;
  }

  .circle-filled:hover {
    background-color: ${colors.accent-1};
    border-width: 0em;
  }

  .circle-empty:hover {
    background-color: ${colors.accent-2};
    border-width: 0em;
  }

  // 
  .circle-filled {
    min-height: 1em;
    min-width: 1em;
    border-style: solid;
    background-color: ${colors.accent-1};
    border-radius: 50%;
  }
  // 
  .circle-empty {
    min-height: 1em;
    min-width: 1em;
    border-style: solid;
    border-color: ${colors.accent-2};
    border-width: 0.1em;
    background: rgba(255, 255, 255, 0.0);
    border-radius: 50%;
  }
      '';
    };
  };
}
