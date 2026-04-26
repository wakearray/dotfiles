{ pkgs, ... }:
{
  config = {
    security.sudo = {
      enable = true;
      extraRules = [{
        commands = [
          {
            command = "${pkgs.systemd}/bin/shutdown";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/poweroff";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }];
    };
  };
}
