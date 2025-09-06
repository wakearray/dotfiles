{ config, lib, ... }:
let
  cfg = config.servers.omadaController;
in
{
  options.servers.omadaController = with lib; {
    enable = mkEnableOption "Enable [Docker Wyze Bridge (redux)](https://github.com/IDisposable/docker-wyze-bridge)";

    useHostnetwork = mkEnableOption "If true, will use host's network, if false will use a docker bridge and open appropriate ports.";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      omadacontroller = {
        image = "idisposablegithub365/wyze-bridge:latest";
        autoStart = true;
        pull = "newer";
        ports = lib.optionals (! cfg.useHostnetwork) [
          "1935:1935/tcp" # RTMP rtmp://localhost:1935/mystream?user=myuser&pass=mypass
          "1936:1936/tcp" # RTMP rtmps://localhost:1936/mystream?user=myuser&pass=mypass
          "2935:2935/tcp" # RTMPS rtmps://localhost:2935/mystream?user=myuser&pass=mypass
          "2936:2936/tcp" # RTMPS rtmps://localhost:2936/mystream?user=myuser&pass=mypass
          "8000:8000/udp" # RTSP UDP/RTP rtsp://localhost:8000/mystream
          "8000:8001/udp" # RTSP UDP/RTCP rtsp://localhost:8001/mystream
          "8002:8002/udp" # RTSP RTP Multicast
          "8003:8003/udp" # RTSP RTCP Multicast control
          "8189:8189/udp" # WebRTC ICE/UDP
          "8322:8322/tcp" # TCP/TLS/RTSPS rtsps://localhost:8322/mystream
          "8554:8554/tcp" # RTSP rtsp://localhost:8554/mystream
          "8888:8888/tcp" # HLS http://localhost:8888/mystream
          "8889:8889/tcp" # WebRTC http://localhost:8889/mystream and http://localhost:8889/mystream/whep
          "8890:8890/udp" # SRT UDP srt://localhost:8890?streamid=read:mystream:myuser:mypass
          "5000:5000/tcp" # WEB-UI http://localhost:5000/mystream
        ];
        environment = {
          TZ = "America/New_York";
        };
        extraOptions = lib.optionals cfg.useHostnetwork [
          "--network=host"
        ];
      };
    };

    # Docker Container Update Timer
    systemd.services."updateWyzeBridgeDockerImages" = {
      description = "Pull latest Docker images and restart services";
      script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        ${dockercli} pull idisposablegithub365/wyze-bridge:latest
        systemctl restart docker-wyzebridge.service
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    # Define the timer
    systemd.timers.updateWyzeBridgeDockerImagesTimer = {
      description = "Daily timer to pull latest Docker images for Docker Wyze Bridge and restart services";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "06:05:00";
        Persistent = true; # Ensures the timer catches up if it missed a run
        Unit = "updateWyzeBridgeDockerImages.service";
      };
    };

    # Ensure nginx and docker are enabled
    servers = {
      docker.enable = true;
    };
  };
}

