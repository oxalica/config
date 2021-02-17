# https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi
{ pkgs, inputs, ... }:
{
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_rpi1;

  boot.kernelParams = [
    "console=ttyS1,115200n8"
  ];

  # Nix flake.
  nix.package = pkgs.nixFlakes;

  networking.wireless = {
    enable = true;
    networks = import "${inputs.secrets}/networks.nix";
  };

  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  users = {
    mutableUsers = false;
    groups."oxa".gid = 1000;
    users."oxa" = {
      isNormalUser = true;
      uid = 1000;
      group = "oxa";
      extraGroups = [ "wheel" ];
      hashedPassword = (import "${inputs.secrets}/passwords.nix").rpi;
    };
  };
}
