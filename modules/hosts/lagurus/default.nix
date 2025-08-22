{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [ vlc mpv ];

    systemd.user.services.catvideo = {
      description = "Plays the string-thing video on startup";
      serviceConfig.PassEnvironment = "DISPLAY";
      script =  ''
        ${pkgs.vlc}/bin/vlc -L -f /home/kent/Desktop/string_video.webm
      '';
      wantedBy = [ "multi-user.target" ]; # starts after login
    };
  };
}
