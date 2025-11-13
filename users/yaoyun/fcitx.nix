{ pkgs, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      librime =
        (prev.librime.override {
          plugins = with pkgs; [
            librime-lua
            librime-octagram
          ];
        }).overrideAttrs
          (old: {
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.luajit ];
          });
    })
  ];
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-gtk
        # rime-data
        # fcitx5-rime
        (fcitx5-rime.override {
          rimeDataPkgs = [ pkgs.rime-ice ];
        })
      ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
          GroupOrder."0" = "Default";
        };
        globalOptions = {
          "HotKey/TriggerKeys"."0" = "Super+space";
          "HotKey/AltTriggerKeys"."0" = "Shift_L";
          "HotKey/EnumerateGroupForwardKeys"."0" = "Super+space";
          "HotKey/EnumerateGroupBackwardKeys"."0" = "Shift+Super+space";
        };
      };
    };
  };

  home.file = {
    ".local/share/fcitx5/rime/default.custom.yaml".text = ''
      patch:
          __include: rime_ice_suggestion:/
      schema_list:
          - schema: double_pinyin_flypy
    '';
  };

  home.sessionVariables = {
    # QT_IM_MODULE = "fcitx";
  };
}
