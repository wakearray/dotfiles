{ lib, config, pkgs, ... }:
let
  locker = config.gui.locker;
  gtklock = locker.gtklock;
in
{
  options.gui.locker.gtklock = with lib; {
    enable = mkEnableOption "Enable GTKlock with PAM support.";
  };

  config = lib.mkIf (locker.enable && gtklock.enable) {
    environment.systemPackages = [ pkgs.gtklock ];

    # Pam settings
    security.pam.services.gtklock = {
      name = "gtklock";
      text = ''
auth include login
      '';
    };
  };
}
