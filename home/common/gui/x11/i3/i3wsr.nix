{ lib, config, pkgs, ... }:
let
  cfg = config.gui.wm.i3.i3wsr;
in
{
  options.gui.wm.i3.i3wsr = with lib; {
    enable = mkEnableOption "Enable i3wsr, a tool for adding icons to i3 workspace names." // { default = config.gui.wm.i3.enable; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Work Space Renamer - Allows for changing the name based on the app
      # https://github.com/roosta/i3wsr
      i3wsr-3
    ];

    xdg.configFile = {
      "i3wsr/config.toml" = {
        enable = config.gui.polybar.enable;
        force = true;
        text = /*toml*/ ''
          [icons]
          Alacritty = ""
          darktable = "󰄄"
          discord = ""
          firefox = "󰈹"
          gmail = "󰊫"
          photopea = ""
          Signal = "󰭹"
          tidal = ""
          youtube = ""

          [aliases.name]
          ".* - YouTube .*" = "youtube"
          ".*Gmail.*" = "gmail"
          ".*Tidal.*" = "tidal"
          "Photopea.*" = "photopea"
          "^Discord .*" = "discord"

          [options]
          no_icon_names = true
          no_names = true

          [general]
          default_icon = ""
          separator = " "
          split_at = ":"
        '';
      };
    };
  };
}
