{ config, lib, pkgs, ... }:
let
    nvimDotfile = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/users/yaoyun/neovim";
in {
        xdg.configFile = {
                nvim.source = nvimDotfile;
            };

        home.packages = [pkgs.neovim];
}
