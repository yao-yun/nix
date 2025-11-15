{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  hyprsplitPackage = inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit;
  cfg = config.yaoyun.hyprland.hyprsplit;
in
{
  options.yaoyun.hyprland.hyprsplit.enable = mkEnableOption "hyprsplit" // {
    default = true;
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      plugins = [ hyprsplitPackage ];
      settings = {
        plugin.hyprsplit = {
          num_workspace = 10;
        };
      };
    };
    yaoyun.hyprland.keybinds.plugin.hyprsplit = true;
  };

}
