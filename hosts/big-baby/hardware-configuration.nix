{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    initrd.kernelModules = [];
    extraModulePackages = [];
    kernelModules = [ "kvm-amd" ];

    # Refuse ICMP echo requests on my desktop/laptop; nobody has any business
    # pinging them, unlike my servers.
    kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  };

  # Modules
  modules.hardware = {
    audio.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    nvidia.enable = true;
    bluetooth.enable = true;
  };

  # CPU
  nix.settings.max-jobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Storage

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4ffaf08b-d78c-437d-ac14-6506f599b991";
    fsType = "ext4";
    };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/93EC-6296";
      fsType = "vfat";
      };

      swapDevices =
        [ { device = "/dev/disk/by-uuid/b266891c-e573-4b06-883d-738b408b56ad"; }
        ];
}
