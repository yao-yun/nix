# a configurable, yet I try to maintain as plain as possible, config of all applications that I use
# and some, like Steam, need a global installation to make things work so check sysmodule
{ lib, pkgs, ... }:
lib.mkMerge [
  {
    nixpkgs.config.allowUnfree = true;
  }
  # qq wayland in non-nixOS
  # {
  #   nixpkgs.overlays = [
  #   ];
  # }

  {
    home.packages = with pkgs; [
      # messenger
      qq
      wechat
      telegram-desktop
      teams-for-linux
    ];
  }
  {
    # -- dev --
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
    };
  }
  # {
  #   # -- gaming --
  #   programs.steam = {
  #     enable = true;
  #     remotePlay.openFirewall = true;
  #     dedicatedServer.openFirewall = true;
  #     localNetworkGameTransfers.openFirewall = true;
  #   };
  # }
  {
    # -- personal --
    home.packages = with pkgs; [
      obsidian
    ];
  }
]
