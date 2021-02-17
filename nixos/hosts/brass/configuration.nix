# https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi
{ lib, config, pkgs, modulesPath, inputs, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/sd-image-raspberrypi.nix")
    ../../modules/rpi-env.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
  };
}
