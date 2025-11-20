{ modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  # nix run github:nix-community/nixos-anywhere -- --flake .#Moonfish -i ~/.ssh/id_ed25519_signing_key --target-host nixos@192.168.0.167
  imports =
  [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    ../../modules
    ../../modules/hosts/moonfish
    ../../users/kent
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Enable binfmt emulation of aarch64-linux.
    # Supports building for phone architectures.
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  networking = {
    networkmanager.enable = true;
    hostName = "Moonfish";
    firewall.enable = true;
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  ## Specs
  #
  # CPU: Ryzen 9 7945hx https://www.amd.com/en/products/processors/laptop/ryzen/7000-series/amd-ryzen-9-7945hx.html
  # GPU: Asrock Challenger RX 9070 XT
  # RAM: 2x32GB Crucial DDR5-5200 SODIMMs
  # SSD: 4TB Crucial P310 PCIe 4.0 NVMe drive

  system.stateVersion = "24.05";
}
