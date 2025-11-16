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
          #NVIDIA_DRIVER_VOLUME_NAME = "nvidia-driver-vol";

          # Force use of a specific GPU (D128 for AMD and D129 for Nvidia)
          WOLF_RENDER_NODE = "/dev/dri/renderD128";

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
          # "nvidia-driver-vol:/usr/nvidia:rw"
        ];
        devices = [
          "/dev/dri"
          "/dev/uinput"
          "/dev/uhid"

          # Used for manual method
          # "/dev/nvidia-uvm"
          # "/dev/nvidia-uvm-tools"
          # "/dev/nvidia-caps/nvidia-cap1"
          # "/dev/nvidia-caps/nvidia-cap2"
          # "/dev/nvidiactl"
          # "/dev/nvidia0"
          # "/dev/nvidia-modeset"
        ];
        ports = [
          # HTTPS
          "47984:47984"
          # HTTP
          "47989:47989"
          # RTSP
          "48010:48010"
          # Control
          "47998:47998"
          "47999:47999"
          "48000:48000"
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

    hardware.uinput.enable = true;

    services.udev.extraRules = /*udev*/ ''
      # Allows Wolf to acces /dev/uinput
      KERNEL=="uinput", SUBSYSTEM=="misc", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"

      # Allows Wolf to access /dev/uhid
      KERNEL=="uhid", TAG+="uaccess"

      # Move virtual keyboard and mouse into a different seat
      SUBSYSTEMS=="input", ATTRS{id/vendor}=="ab00", MODE="0660", GROUP="input", ENV{ID_SEAT}="seat9"

      # Joypads
      SUBSYSTEMS=="input", ATTRS{name}=="Wolf X-Box One (virtual) pad", MODE="0660", GROUP="input"
      SUBSYSTEMS=="input", ATTRS{name}=="Wolf PS5 (virtual) pad", MODE="0660", GROUP="input"
      SUBSYSTEMS=="input", ATTRS{name}=="Wolf gamepad (virtual) motion sensors", MODE="0660", GROUP="input"
      SUBSYSTEMS=="input", ATTRS{name}=="Wolf Nintendo (virtual) pad", MODE="0660", GROUP="input"
    '';

    # Enabled for nvidia-container-toolkit method
    # hardware.nvidia-container-toolkit = {
    #   enable = true;
    #   package = pkgs.nvidiaCtkPackages.nvidia-container-toolkit-docker;
    # };

    systemd.services.nvidia-container-cli-info = {
      description = "Run nvidia-container-cli --load-kmods info on boot";
      wantedBy = [ "multi-user.target" ];
      after = [ "nvidia-persistenced.service" ]; # Ensure NVIDIA services are up
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-cli --load-kmods info";
        User = "root"; # Run as root for necessary permissions
      };
    };

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
        47998
        47999
        48000
        # Video
        48100
        # Audio
        48200
      ];
    };
  };
}
