{ config, lib, pkgs, modulesPath, ... }:

{
  # imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [
    "kvm-amd"
    "nct6775" # Fan control
  ];
  boot.extraModulePackages = [ ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max"; # Don't clip boot menu.
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.timeout = 1;

  # For dev.
  boot.binfmt = {
    emulatedSystems = [ "riscv64-linux" "aarch64-linux" ];
    registrations."riscv64-linux" = {
      preserveArgvZero = true;
      interpreter = let
        qemu = (lib.systems.elaborate { system = "riscv64-linux"; }).emulator pkgs;
      in lib.mkForce ''${qemu} -0 "$2" "$1" "''${@:3}" #'';
    };
    registrations."aarch64-linux".preserveArgvZero = true;
  };

  boot.initrd.luks.devices."unluks" = {
    device = "/dev/disk/by-uuid/21764e86-fde3-4e51-9652-da9adbdeeb34";
    preLVM = true;
    allowDiscards = true;
  };

  fileSystems = let
    btrfs = options: {
      device = "/dev/disk/by-uuid/7219f4b1-a9d1-42a4-bfc9-386fa919d44b";
      fsType = "btrfs";
      # zstd:1  W: ~510MiB/s
      # zstd:3  W: ~330MiB/s
      options = [ "compress-force=zstd:1" ] ++ options;
    };
  in {

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/DDBD-2F2B";
      fsType = "vfat";
    };

    "/.subvols" = btrfs [ "noatime" ];
    "/nix" = btrfs [ "subvol=/@nix" "noatime" ];
    "/var" = btrfs [ "subvol=/@var" "noatime" ];
    "/home/oxa" = btrfs [ "subvol=/@home-oxa" "noatime" ];
  };

  swapDevices = [
    {
      device = "/var/swapfile";
      # FIXME: Auto creation sucks on btrfs.
      # size = 16 * 1024; # 16G
    }
  ];

  systemd.tmpfiles.rules = [
    "d /tmp 1777 root root 2d"
    "q /var/tmp 1777 root root 15d"
  ];
  # We already wrote our rules.
  environment.etc."tmpfiles.d/tmp.conf".source =
    lib.mkForce (pkgs.writeText "dummy-tmp-conf" "");

  environment.etc = {
    "machine-id".source = "/var/machine-id";
    "ssh/ssh_host_rsa_key".source = "/var/ssh/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/var/ssh/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/var/ssh/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/var/ssh/ssh_host_ed25519_key.pub";
  };

  # High-DPI console
  # hardware.video.hidpi.enable = true; # It use 80x50 mode, which is too big and has wrong aspect ratio.
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  console.earlySetup = true;
}
