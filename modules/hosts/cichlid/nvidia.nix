{ config, ... }:
{
  # Load "nvidia" driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    # Enable graphics driver
    opengl = {
      enable = true;
      driSupport = true;
    };
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management.
      # Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues
      # or application crashes after waking up from sleep.
      # This fixes it by saving the entire VRAM memory to
      # /tmp/ instead of just the bare essentials.
      powerManagement.enable = false;

      # Use the NVidia open source kernel module (not to be confused
      # with the independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures.
      # Full list of supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently "beta quality",
      # so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver
      # version for your specific GPU.
      # https://nixos.wiki/wiki/Nvidia#Determining_the_Correct_Driver_Versionn
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # Forcing a full composition pipeline has been reported to reduce
      # the performance of some OpenGL applications and may produce issues
      # in WebGL. It also drastically increases the time the driver needs
      # to clock down after load.
      forceFullCompositionPipeline = false;
    };
  };
}
