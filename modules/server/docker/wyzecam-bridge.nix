{ config, ... }:
{
  # docker-wyze-bridge - WebRTC/RTSP/RTMP/LL-HLS bridge for Wyze cams in a docker container
  # https://github.com/mrlt8/docker-wyze-bridge
  virtualisation = {
    # Docker containers
    oci-containers = {
      backend = "docker";
      containers = {
        wyze-bridge = {
          image = "mrlt8/wyze-bridge:latest";
          autoStart = true;
          environment = {
            # [OPTIONAL] Credentials can be set in the WebUI
            # API Key and ID can be obtained from the wyze dev portal:
            # https://developer-api-console.wyze.com/#/apikey/view
            # WYZE_EMAIL = "";
            # WYZE_PASSWORD = "";
            # API_ID = "";
            # API_KEY = "";
            # [OPTIONAL] IP Address of the host to enable WebRTC e.g.,:
            WB_IP = "192.168.0.46";
            # WebUI and Stream authentication:
            WB_AUTH = "True"; # Set to false to disable web and stream auth.
            # WB_USERNAME = "";
            # WB_PASSWORD = "";
          };
          ports = [
            "1935:1935" # RTMP
            "8554:8554" # RTSP
            "8888:8888" # HLS
            "8889:8889" #WebRTC
            "8189:8189/udp" # WebRTC/ICE
            "5000:5000" # WEB-UI
          ];
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 1935 8554 8888 8889 5000 ];
    allowedUDPPorts = [ 8189 ];
  };
}
