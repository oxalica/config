{ inputs, overlays, ... }:
inputs.nixpkgs-stable.lib.nixosSystem {
  system = "armv6l-linux";
  modules = [
    ({ lib, modulesPath, ... }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/sd-image-raspberrypi.nix")
        ../../modules/rpi-env.nix
      ];
    })
  ];
  specialArgs.inputs = inputs // { nixpkgs = inputs.nixpkgs-stable; };
}
