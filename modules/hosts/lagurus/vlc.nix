{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Video Player
    vlc
  ];

  systemd.user.services.catvideo = {
    description = "plays the string-thing video on startup";
    serviceConfig.PassEnvironment = "DISPLAY";
    script = let vlc = "${pkgs.vlc}/bin/vlc";
    in ''
      #!/bin/sh
      ${vlc} -L -f /home/kent/Desktop/string_video.webm
    '';
    wantedBy = [ "multi-user.target" ]; # starts after login
  };

}
