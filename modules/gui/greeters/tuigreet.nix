{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  tuigreet = gui.greeter.tuigreet;

  hyprlandStart = "${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop";
in
{
  options.gui.greeter.tuigreet = with lib; {
    enable = mkEnableOption "Enable greetd with tui-greet to launch hyprland";
  };

  config = lib.mkIf (gui.enable && tuigreet.enable) {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"${hyprlandStart}\"";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = [ pkgs.tuigreet ];
  };
}
