{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  hyprland-packages = inputs.hyprland.packages.${system};
in
{
  imports = [
    ../kitty.nix
    ./keybind.nix
    ./hy3.nix
    ./hyprsplit.nix
  ];
  config = {
    wayland.windowManager.hyprland = lib.mkMerge [
      {
        enable = true;
        # use flake
        package = hyprland-packages.hyprland;
        portalPackage = hyprland-packages.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
        systemd = {
          enable = true;
          variables = [ "--all" ];
        };
        settings = {
          debug.disable_logs = false;

          # variables
          "$terminal" = "kitty";
          "$fileManager" = "$terminal -- fish -i -c yazi";
          "$webbrowser" = "zen-browser --new-window";

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "XDG_MENU_PREFIX,arch-"
          ];
          binds = {
            disable_keybind_grabbing = false;
            window_direction_monitor_fallback = true;
            hide_special_on_workspace_change = true;
          };
          # look and feel
          xwayland.force_zero_scaling = true;
          general = {
            gaps_in = 3;
            gaps_out = 10;
            border_size = 2;
            resize_on_border = true;
            hover_icon_on_border = true;
          };
          decoration = {
            rounding = 10;
            active_opacity = 1.0;
            inactive_opacity = 0.95;
            shadow = {
              enabled = true;
              render_power = 3;
              range = 4;
            };
            blur = {
              enabled = true;
              size = 5;
              passes = 4;
              vibrancy = 0.1696;
              xray = false;
              new_optimizations = true;
              popups = true;
              input_methods = true;
            };
          };
          input = {
            touchpad.natural_scroll = true;
          };
          animations = {
            enabled = true;

            # Animation curves
            bezier = [
              "specialWorkSwitch, 0.05, 0.7, 0.1, 1"
              "emphasizedAccel, 0.3, 0, 0.8, 0.15"
              "emphasizedDecel, 0.05, 0.7, 0.1, 1"
              "standard, 0.2, 0, 0, 1"
            ];

            # Animation configs
            animation = [
              "layersIn, 1, 5, emphasizedDecel, slide"
              "layersOut, 1, 4, emphasizedAccel, slide"
              "fadeLayers, 1, 5, standard"

              "windowsIn, 1, 5, emphasizedDecel"
              "windowsOut, 1, 3, emphasizedAccel"
              "windowsMove, 1, 6, standard"
              "workspaces, 1, 5, standard"

              "specialWorkspace, 1, 4, specialWorkSwitch, slidefadevert 15%"

              "fade, 1, 6, standard"
              "fadeDim, 1, 6, standard"
              "border, 1, 6, standard"
            ];
          };
          misc = {
            force_default_wallpaper = 0;
          };
        };
        extraConfig = ''
          monitor = eDP-1,2560x1600@165.0,0x297,1.33
          monitor = eDP-2,2560x1600@165.0,0x297,1.33
          monitor = DP-1,2560x1440@170.0,1920x0,1
        '';
      }
    ];
  };
}
