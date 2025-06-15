{ pkgs, ... }:
let
  hyprlandStart = "${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop";
in
{
  config = {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${hyprlandStart}";
          user = "entertainment";
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
