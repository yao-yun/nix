{ inputs, pkgs, ... }:
let
  system = pkgs.system;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      linux-pam = inputs.pam_shim.packages.${system}.default;
    })
  ];
}
