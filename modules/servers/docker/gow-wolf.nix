{ config, lib, pkgs, ... }:
let
  cfg = config.servers.docker.gow.wolf;
in
{
  options.servers.docker.gow.wolf = with lib; {
    enable = mkEnableOption "Enable a Games on Whales - Wolf instance using Docker.";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      wolf = {
        image = "ghcr.io/games-on-whales/wolf:stable";
        environment = {
          # Used for manual method
          NVIDIA_DRIVER_VOLUME_NAME = "nvidia-driver-vol";
          WOLF_RENDER_NODE = "/dev/dri/renderD129";

          # Used for nvidia-container-toolkit method
          # NVIDIA_DRIVER_CAPABILITIES = "all";
          # NVIDIA_VISIBLE_DEVICES = "all";
        };
        volumes = [
          "/etc/wolf/:/etc/wolf:rw"
          "/var/run/docker.sock:/var/run/docker.sock:rw"
          "/dev/:/dev/:rw"
          "/run/udev:/run/udev:rw"

          # Used for manual method
          "nvidia-driver-vol:/usr/nvidia:rw"
        ];
        devices = [
          "/dev/dri"
          "/dev/uinput"
          "/dev/uhid"

          # Used for manual method
          "/dev/nvidia-uvm"
          "/dev/nvidia-uvm-tools"
          "/dev/nvidia-caps/nvidia-cap1"
          "/dev/nvidia-caps/nvidia-cap2"
          "/dev/nvidiactl"
          "/dev/nvidia0"
          "/dev/nvidia-modeset"
        ];
        ports = [
          # HTTPS
          "47984:47984"
          # HTTP
          "47989:47989"
          # RTSP
          "48010:48010"
          # Control
          "47999:47999"
          # Video
          "48100:48100"
          # Audio
          "48200:48200"
        ];
        extraOptions = [
          "--device-cgroup-rule=c 13:* rmw"
          "--network=host"
          # Used for nvidia-container-toolkit method
          # "--gpus=all"
        ];
      };
    };

    # Enabled for nvidia-container-toolkit method
    # hardware.nvidia-container-toolkit = {
    #   enable = true;
    #   package = pkgs.nvidiaCtkPackages.nvidia-container-toolkit-docker;
    # };

    environment.systemPackages = with pkgs; [
      libnvidia-container
    ];

    networking.firewall = {
      allowedTCPPorts = [
        # HTTPS
        47984
        # HTTP
        47989
        # RTSP
        48010
      ];
      allowedUDPPorts = [
        # Control
        47999
        # Video
        48100
        # Audio
        48200
      ];
    };
  };
}
