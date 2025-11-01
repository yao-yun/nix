{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  hy3Package = inputs.hy3.packages.${pkgs.stdenv.hostPlatform.system}.hy3;
  cfg = config.yaoyun.hyprland.hy3;
in
{
  options.yaoyun.hyprland.hy3.enable = mkEnableOption "use hy3 layout and keybinds" // {
    default = true;
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      plugins = [ hy3Package ];
      settings = {
        general.layout = "hy3";
        plugin.hy3 = {
          tabs = {
            height = 25;
            padding = 5;
            radius = 10;
            from_top = true;
            render_text = true;
            text_height = 8;
          };
          autotile = {
            enable = true;
            trigger_width = 800;
            trigger_height = 400;
          };
        };
      };
    };

    yaoyun.hyprland.keybinds = {
      prefix.layout = "hy3:";
    };
  };
}
