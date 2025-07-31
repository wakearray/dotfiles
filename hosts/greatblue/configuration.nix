{ ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hosts/greatblue
    ../../users/kent
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Enable binfmt emulation of aarch64-linux.
    # Supports building for phone architectures.
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "GreatBlue";
    firewall.enable = true;
  };

  # Enable keyboard access
  hardware = {
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;

    # Enable the open sourve Vulkan driver for AMD GPUs
    # Steam will launch with amdvlk by default when present
    # If needed, you can launch steam with the older RADV drivers with the command:
    # `AMD_VULKAN_ICD="RADV" steam`
    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };

  system.stateVersion = "23.11";
}
