{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  tuigreet = gui.greeter.tuigreet;
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd '${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop'";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      greetd.tuigreet
    ];
  };
}
