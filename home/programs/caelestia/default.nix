{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  # enable caelestia
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];
  # deps
  home.packages = with pkgs; [
    gpu-screen-recorder
  ];
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    cli = {
      enable = true;
    };
    settings = {
      general = {
        apps = {
          # TODO
          terminal = [ "kitty" ];
          explorer = [ "nautilus" ];
          playback = [ "mpv" ];
        };
        idle = {
          inhibitWhenAudio = true;
          lockBeforeSleep = false; # 2025-11-15 bypass pam issue
          timeouts = [
            {
              timeout = 180;
              idleAction = [ "hyprlock" ]; # 2025-11-15 bypass pam issue
              # idleAction = "lock"
            }
            {
              timeout = 300;
              idleAction = "dpms off";
              returnAction = "dpms on";
            }
            {
              timeout = 600;
              idleAction = [
                "systemctl"
                "suspend"
              ];
            }
          ];
        };
      };
      bar = {
        clock.showIcon = true;
        status = {
          showAudio = true;
          showMicrophone = true;
        };
        tray = {
          recolour = true;
        };
        workspaces = {
          activeTrail = true;
          shown = 10;
        };
      };
      border = {
        rounding = (
          with config.wayland.windowManager.hyprland.settings; decoration.rounding + general.gaps_out
        );
        thickness = 10;
      };
      paths.wallpaperDir = "~/Pictures/Wallpapers";
      launcher = {
        actionPrefix = "/";
        enableDangerousActions = true;
        maxShown = 7;
        useFuzzy = {
          apps = true;
        };
      };
      osd = {
        enableMicrophone = true;
      };
    };
  };
}
