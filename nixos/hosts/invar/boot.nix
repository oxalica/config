{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [
    "kvm-amd"
    "nct6775" # Fan control
  ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."unluks" = {
    device = "/dev/disk/by-uuid/21764e86-fde3-4e51-9652-da9adbdeeb34";
    preLVM = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b009a0bd-0db7-4ec5-b6d0-ff290488d6a4";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DDBD-2F2B";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/7219f4b1-a9d1-42a4-bfc9-386fa919d44b";
    fsType = "btrfs";
  };

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 16 * 1024; # 16G
    }
  ];

  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  console.earlySetup = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
}