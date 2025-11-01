{ lib, config, ... }:
let
  util = import ./util.nix { inherit lib; };
  cfg = config.yaoyun.hyprland.keybinds;
  _mm = cfg.mainMod;
  _ms = _mm + "+SHIFT";
in
with lib;
with util;
{
  options.yaoyun.hyprland.keybinds = {
    enable = mkEnableOption "Yaoyun's hyprland keybinds" // {
      default = true;
    };
    mainMod = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
      description = "Main modifier key for hyprland";
    };

    plugin = {
      hy3 = mkEnableOption "Use hy3 related keybinds";
    };

    prefix = {
      layout = mkOption {
        default = "";
        description = ''
          prefix before `movefocus` `movewindow` `movetoworkspace`
        '';
        type = types.str;
      };

      workspace = mkOption {
        default = "";
        description = ''
          prefix before workspace
        '';
        type = types.str;
      };
    };
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = mkMerge [
      {
        settings."$mainMod" = cfg.mainMod;
        extraConfig = ''
          exec = hyprctl dispatch submap global
        '';
      }
      (mkSubmap "global" [
        # shortcuts
        (mkBinds _mm [ "Q" "E" ] "exec" [ "$terminal" "$fileManager" ] "")
        # -- Focus and movement --
        # change state
        (mkBindsParamed [ _mm _ms ] "F" [
          "fullscreen"
          "fullscreenstate, 0 2"
        ] "")
        (mkBinds _ms "C" "${cfg.prefix.layout}killactive" "" "")
        # navigation
        (mkBinds [ _mm _ms ] [ "H" "J" "K" "L" ]
          [ "${cfg.prefix.layout}movefocus" "${cfg.prefix.layout}movewindow" ]
          [ "l" "u" "d" "r" ]
          ""
        )
        # monitor
        (mkBinds _mm [ "bracketleft" "bracketright" ] "focusmonitor" [
          "l"
          "r"
        ] "")
        (mkBinds _ms [ "bracketleft" "bracketright" ] "${cfg.prefix.layout}movewindow" [
          "mon:l"
          "mon:r"
        ] "")
        # workspace
        (mkNumBinds _mm (i: "${cfg.prefix.workspace}workspace, ${toString i}") "")
        (mkNumBinds _ms (i: "${cfg.prefix.layout}movetoworkspace, ${toString i}") "")
        (mkBinds _ms [ "mouse_down" "mouse_up" ] "${cfg.prefix.workspace}workspace" [ "r+1" "r-1" ] "")
        # special Workspace
        (mkBinds _mm "X" "togglespecialworkspace" "magic" "")
        (mkBinds _ms "X" "${cfg.prefix.layout}movetoworkspace" "special:magic" "")
      ])
      (mkSubmap "resize" [
        (mkBinds "" [ "H" "J" "K" "L" ] "resizeactive" [
          "-15 0"
          "0 -15"
          "0 15"
          "15 0"
        ] "")
        (mkBinds "SHIFT" [ "H" "J" "K" "L" ] "${cfg.prefix.layout}movefocus" [
          "l"
          "u"
          "d"
          "r"
        ] "")
        (mkBinds "" "escape" "submap" "global" "")
      ])
      (mkSubmap "global" [
        (mkBinds _ms "R" "submap" "resize" "")
      ])
      (mkIf config.programs.caelestia.enable (
        mkSubmap "global" [
          (mkBinds _mm [ "R" "P" ] "global" [
            "caelestia:launcher"
            "caelestia:showall"
          ] "")
          # (mkBinds _ms "L" "global" "caelestia:lock" "")
          (mkBinds _ms "L" "exec" "caelestia shell -d" "l")
          (mkBinds _ms "L" "global" "caelestia:lock" "l")
          (mkBinds _mm (
            builtins.genList (i: "mouse:" + toString (i + 272)) 6
            ++ [
              "catchall"
              "mouse_up"
              "mouse_down"
            ]
          ) "global" "caelestia:launcherInterrupt" "in")
        ]
      ))
    ];
  };
}
