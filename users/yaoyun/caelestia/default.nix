{
  inputs,
  config,
  pkgs,
  ...
}:
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
      border = {
        rounding = (
          with config.wayland.windowManager.hyprland.settings; decoration.rounding + general.gaps_out
        );
        thickness = 10;
      };
      paths.wallpaperDir = "~/Pictures/Wallpaper";
    };
  };
}
