{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./stylix.nix
    ./fcitx.nix
    ./caelestia
    ./hyprland
    # ./pam.nix
    inputs.pam_shim.homeModules.default
  ];
  config = {
    pamShim.enable = true;
    programs.hyprlock = {
      enable = true;
      package = config.lib.pamShim.replacePam pkgs.hyprlock;
    };
    # Authentication quirks with PAM
    # home.pam = {
    #   chkpwdPath = "/usr/bin/unix_chkpwd";
    #   # overridePackages = [ "i3lock-color" ];
    # };
    home.packages = with pkgs; [
      # mimeo
      xdg-utils
    ];
    xdg.dataFile."flatpak/overrides/global".text = ''
      [Context]
      sockets=wayland
    '';
    home.sessionVariables = {
      NIXOS_OZONE_WL = 1;
    };
  };

}
