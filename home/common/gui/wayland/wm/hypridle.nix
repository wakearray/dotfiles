{ lib, config, ... }:
let
  idle = config.home.wm.hypridle;
in
{
  options.home.wm.hypridle = with lib; {
    enable = mkEnableOption "Enable an opinionated hypridle config.";

    settings = mkOption {
      type = types.attrs;
      default = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "systemctl suspend && gtklock";
        };

        listener = [
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
      description = "Attribute set of settings making up the hypridle config as noted here: https://github.com/hyprwm/hypridle";
    };
  };

  config = {
    services.hypridle = {
      enable = true;
      settings = idle.settings;
    };
  };
}
