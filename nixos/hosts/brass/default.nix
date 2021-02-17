{ inputs, overlays, ... }:
inputs.nixpkgs-stable.lib.nixosSystem {
  system = "armv6l-linux";
  modules = [
    ./configuration.nix
  ];
  specialArgs.inputs = inputs // { nixpkgs = inputs.nixpkgs-stable; };
}
