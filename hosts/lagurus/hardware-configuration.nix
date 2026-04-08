{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/luks-9a10d99b-0dfd-499c-b226-f4dd0336751d";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-9a10d99b-0dfd-499c-b226-f4dd0336751d".device = "/dev/disk/by-uuid/9a10d99b-0dfd-499c-b226-f4dd0336751d";

  fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/397C-9FD7";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s21f0u5c2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
