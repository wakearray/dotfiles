{ config, lib, pkgs, ... }:
let
  cfg = config.servers.docker.gow.wolf;
in
{
  options.servers.docker.gow.wolf = with lib; {
    enable = mkEnableOption "Enable a Games on Whales - Wolf instance using Docker.";

    nvidiaManual = mkEnableOption "Use the more reliable manual method of the Nvidia driver.";
    nvidiaAutomatic = mkEnableOption "Use the less reliable automatic method of configuring the Nvidia driver.";

    networkHostMode = mkEnableOption ''
      If enabled, the flag `--network=host` is used. If disabled, the following ports are opened:
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
    '';

    renderNode = mkOption {
      type = types.str;
      default = "/dev/dri/renderD128";
      description = ''
      The default render node used for virtual desktops.
      Use the command `ls -l /sys/class/drm/renderD*/device/driver` to determine which render node is assigned to each GPU on multi GPU systems.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions =[
      {
        assertion = !(cfg.nvidiaManual && cfg.nvidiaAutomatic);
        message = "Automatic and manual Nvidia driver setup methods can't be used together. Choose one and disable the other.";
      }
    ];

    virtualisation.oci-containers.containers = {
      wolf = {
        image = "ghcr.io/games-on-whales/wolf:stable";
        environment = {
          WOLF_RENDER_NODE = cfg.renderNode;
        } // lib.optionalAttrs cfg.nvidiaManual {
          NVIDIA_DRIVER_VOLUME_NAME = "nvidia-driver-vol";
        } // lib.optionalAttrs cfg.nvidiaAutomatic {
          NVIDIA_DRIVER_CAPABILITIES = "all";
          NVIDIA_VISIBLE_DEVICES = "all";
        };
        volumes = [
          "/etc/wolf/:/etc/wolf:rw"
          "/var/run/docker.sock:/var/run/docker.sock:rw"
          "/dev/:/dev/:rw"
          "/run/udev:/run/udev:rw"
        ] ++ lib.optionals cfg.nvidiaManual [
          "nvidia-driver-vol:/usr/nvidia:rw"
        ];
        devices = [
          "/dev/dri"
          "/dev/uinput"
          "/dev/uhid"
        ] ++ lib.optionals cfg.nvidiaManual [
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
        ] ++ lib.optionals cfg.nvidiaAutomatic [
          "--gpus=all"
        ] ++ lib.optionals cfg.networkHostMode [
          "--network=host"
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

    hardware = {
      nvidia-container-toolkit = lib.mkIf cfg.nvidiaAutomatic {
        enable = true;
        package = pkgs.nvidiaCtkPackages.nvidia-container-toolkit-docker;
      };
      nvidia.modesetting.enable = (cfg.nvidiaManual || cfg.nvidiaAutomatic);
    };

    systemd.services = lib.mkIf cfg.nvidiaManual {
      nvidia-container-cli-info = {
        description = "Run nvidia-container-cli --load-kmods info on boot";
        wantedBy = [ "multi-user.target" ];
        after = [ "nvidia-persistenced.service" ]; # Ensure NVIDIA services are up
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-cli --load-kmods info";
          User = "root";
        };
      };
    };

    system.userActivationScripts = {
      # This is not particularly fast, but it is idempetent and completely automates the process.
      nvidiaDriverVolSetup = lib.mkIf cfg.nvidiaManual {
        text = ''
          ${pkgs.curl}/bin/curl https://raw.githubusercontent.com/games-on-whales/gow/master/images/nvidia-driver/Dockerfile | ${pkgs.docker}/bin/docker build -t gow/nvidia-driver:latest -f - --build-arg NV_VERSION=$(${pkgs.coreutils}/bin/cat /sys/module/nvidia/version) .
          ${pkgs.docker}/bin/docker create --rm --mount source=nvidia-driver-vol,destination=/usr/nvidia gow/nvidia-driver:latest sh
        '';
      };
    };


    environment.systemPackages = [ ] ++ lib.optionals (cfg.nvidiaManual || cfg.nvidiaAutomatic) [
      pkgs.libnvidia-container
    ] ++ lib.optionals cfg.nvidiaAutomatic [
      pkgs.nvidia-container-toolkit
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
