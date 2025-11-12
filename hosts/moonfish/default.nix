{ ... }:
{
  imports =
  [
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
    graphics.enable = true;
    nvidia = {
      open = false;  # The GTX 1080 is not supported by the open source userspace drivers
      prime = {
        nvidiaBusId = "PCI:1:0:0"; # EVGA Nvidia GTX 1080 OC
        amdgpuBusId = "PCI:4:0:0"; # AMD Radeon 610M
      };
    };
  };

  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  ## Specs
  #
  # CPU: Ryzen 9 7945hx https://www.amd.com/en/products/processors/laptop/ryzen/7000-series/amd-ryzen-9-7945hx.html
  # GPU: EVGA Nvidia GTX 1080 OC
  # RAM: 2x32GB Crucial DDR5-5200 SODIMMs
  # SSD: 4TB Crucial P310 PCIe 4.0 NVMe drive

  ## lspci output
  #
  # 00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14d8
  # 00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Device 14d9
  # 00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14da
  # 00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 14db
  # 00:01.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 14db
  # 00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14da
  # 00:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14da
  # 00:03.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 14db
  # 00:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14da
  # 00:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14da
  # 00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 14dd
  # 00:08.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 14dd
  # 00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev 71)
  # 00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 51)
  # 00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14e0
  # 00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14e1
  # 00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14e2
  # 00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14e3
  # 00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14e4
  # 00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14e5
  # 00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14e6
  # 00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 14e7
  # 01:00.0 VGA compatible controller: NVIDIA Corporation GP104 [GeForce GTX 1080] (rev a1)
  # 01:00.1 Audio device: NVIDIA Corporation GP104 High Definition Audio Controller (rev a1)
  # 02:00.0 Non-Volatile memory controller: Micron/Crucial Technology P2 [Nick P2] / P3 / P3 Plus NVMe PCIe SSD (DRAM-less) (rev 01)
  # 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller (rev 05)
  # 04:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Raphael (rev d8)
  # 04:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Rembrandt Radeon High Definition Audio Controller
  # 04:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 19h PSP/CCP
  # 04:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Device 15b6
  # 04:00.4 USB controller: Advanced Micro Devices, Inc. [AMD] Device 15b7
  # 04:00.6 Audio device: Advanced Micro Devices, Inc. [AMD] Family 17h/19h HD Audio Controller
  # 05:00.0 USB controller: Advanced Micro Devices, Inc. [AMD] Device 15b8

  system.stateVersion = "24.05";
}
