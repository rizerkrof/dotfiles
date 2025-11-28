{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    initrd.kernelModules = [ ];
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" "rtw89_8922ae" ];

    # Refuse ICMP echo requests on my desktop/laptop; nobody has any business
    # pinging them, unlike my servers.
    kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    # kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.wireless.enable = false;

  # Modules
  modules.hardware = {
    audio.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    nvidia.enable = false;
    bluetooth.enable = true;
  };

  # CPU
  nix.settings.max-jobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Storage

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/11378771-9189-4b08-a20b-9a8cb121399a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A710-B7CA";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/cc251576-327f-405e-8f5d-a54ecb548b28"; }
  ];
}
