{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
  {
    device = "/dev/disk/by-uuid/a6907f9a-5307-4f27-9db8-95a7ab0105a6";
    fsType = "ext4";
  };

  fileSystems."/boot" =
  {
    device = "/dev/disk/by-uuid/59C4-FABD";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/dca51b66-8102-4cbd-8570-b2522a0601f0"; }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
