{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  tuigreet = gui.greeter.tuigreet;

  hyprlandStart = "${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop";
in
{
  options.gui.greeter.tuigreet = with lib; {
    enable = mkEnableOption "Enable greetd with tui-greet to launch hyprland";

    autoLogin = {
      enable = mkEnableOption "Enable first boot logging in without a password.";

      user = mkOption {
        type = types.str;
        default = "entertainment";
        description = "The name of the user who should be auto logged in.";
      };
    };
  };

  config = lib.mkIf (gui.enable && tuigreet.enable) {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = lib.mkIf (tuigreet.autoLogin.enable) {
          command = "${hyprlandStart}";
          user = tuigreet.autoLogin.user;
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd '${hyprlandStart}";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      greetd.tuigreet
    ];
  };
}
