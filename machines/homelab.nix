{ config, lib, pkgs, ... }:

{
  imports = [
    ../roles/common.nix
    ../roles/multimedia.nix
    ../roles/desktop.nix
    ../roles/i3.nix
    ../roles/development.nix
    ../roles/services.nix
    ../roles/electronics.nix
    #../roles/games.nix
    #../roles/nas.nix
    #../roles/transmission.nix
    #../roles/plex.nix
    #../roles/virtualization.nix
  ];

  boot = {
    initrd.availableKernelModules = [ "ata_generic" "ehci_pci" "ahci" "mpt3sas" "isci" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-intel"
      "vfio"
      "vfio_pci"
      "vfio_iommu_type1"
      "tun"
      "virtio"
      "coretemp"
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = "1048576";
    };
    kernelParams = [
      "quiet nomodeset"

      # Use IOMMU
      "intel_iommu=on"
      "i915.preliminary_hw_support=1"
      "vfio_iommu_type1.allow_unsafe_interrupts=1"
      "kvm.allow_unsafe_assigned_interrupts=1"

      # 05:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP106 [GeForce GTX 1060 6GB] [10de:1c03] (rev a1)
      # 05:00.1 Audio device [0403]: NVIDIA Corporation GP106 High Definition Audio Controller [10de:10f1] (rev a1)

      # Assign devices to vfio
      # "vfio-pci.ids=10de:1c03,10de:10f1"

      # Needed by OS X
      "kvm.ignore_msrs=1"

      # Only schedule cpus 0,1
      # "isolcpus=1-3,5-7"
    ];
    blacklistedKernelModules = [
      "nouveau"
    ];
    extraModulePackages = [];
    extraModprobeConfig = ''
    '';

    supportedFilesystems = [ "zfs" ];
    zfs.enableUnstable = true;

    loader = {
      systemd-boot.enable = true;
      generationsDir.enable = false;
      generationsDir.copyKernels = false;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };

    cleanTmpDir = true;
  };

  fileSystems."/" =
    { device = "main/ROOT/nixos";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/01A9-F338";
      fsType = "vfat";
    };

  swapDevices = [ ];

  networking = {
    hostId = "8425e349";
    hostName = "homelab";
  };

  services = {
    unifi.enable = true;
    xserver = {
      videoDrivers = [ "nvidia" ];
      displayManager.xserverArgs = [ "-dpi 92" ];
    };
  };

  environment = {
    etc."X11/Xresources".text = ''
      Xft.dpi: 92
    '';
  };

  nix.maxJobs = lib.mkDefault 40;

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "performance";
  };
}
