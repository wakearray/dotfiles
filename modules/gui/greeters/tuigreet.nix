{ lib, config, pkgs, ... }:
let
  gui = config.gui;
  tuigreet = gui.greeter.tuigreet;

  hyprlandStart = "${pkgs.uwsm}/bin/uwsm start -- hyprland-uwsm.desktop";
in
{
  options.gui.greeter.tuigreet = with lib; {
    enable = mkEnableOption "Enable [greetd](https://git.sr.ht/~kennylevinsen/greetd) with [tuigreet](https://github.com/apognu/tuigreet) to launch hyprland.

***Note:***
  As `tuigreet` runs in the terminal after boot, occasionally slow systemd processes may write ontop of the UI. While there are no actual solutions to this, this module includes all the documented mitigations that I have found.";
  };

  config = lib.mkIf (gui.enable && tuigreet.enable) {
    #
    # greetd with tuigreet has serious issues with
    # systemd console logging spam being writen on
    # top of it. While there's no true solution,
    # this module contains most documented mitigations.
    #
    # Sadly, none of these mitigations work 100%
    # of the time for 100% of users.
    #
    services.greetd = {
      enable = true;
      # Run greetd on tty2 to avoid systemd logging spam
      # A recent change in the management of NixPkgs has removed this option
      # vt = 2;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"${hyprlandStart}\"";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = [ pkgs.tuigreet ];

    # Ensure all systemd logging happens on tty1.
    # This allows running tuigreet on a different
    # vt to avoid console spam.
    # Edit: All greeters in Nixpkgs are now being
    # forced to use tty1.
    boot.kernelParams = [ "console=tty2" ];

    # Wait till multi-user target is triggered
    # to avoid the majority of the systemd logging spam
    systemd.services.greetd = {
      unitConfig = {
        After = lib.mkOverride 0 [ "multi-user.target" ];
      };
      serviceConfig = {
        # Use `idle` rather than `simple` to help avoid systemd logging spam
        Type = "idle";
      };
    };
  };
}
