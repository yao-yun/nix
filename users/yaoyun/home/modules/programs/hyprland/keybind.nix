{
  lib,
  pkgs,
  config,
  ...
}:
let
  mkIfElse =
    cond: if_exp: else_exp:
    lib.mkMerge [
      (lib.mkIf (cond) if_exp)
      (lib.mkIf (!cond) else_exp)
    ];
  util = import ./util.nix { inherit lib; };
  cfg = config.yaoyun.hyprland.keybinds;
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
      hyprsplit = mkEnableOption "Use hyprsplit keybinds";
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
    wayland.windowManager.hyprland =
      let
        _mm = cfg.mainMod;
        _ms = _mm + "+SHIFT";
        _layout = if cfg.plugin.hy3 then "hy3:" else cfg.prefix.layout;
        _ws = if cfg.plugin.hyprsplit then "split:" else cfg.prefix.workspace;
      in
      mkMerge [
        {
          settings."$mainMod" = cfg.mainMod;
          extraConfig = ''
            exec = hyprctl dispatch submap global
          '';
        }
        # --- Gestures ---
        {
          settings.gesture = [
            "4, horizontal, workspace"
            "4, vertical, special, magic"
            "3, pinchin, resize"
            "3, swipe, move"
          ];
        }
        # --- basic ---
        (mkSubmap "global" [
          # shortcuts
          (mkBinds _mm [ "Q" "E" "W" ] "exec" [ "$terminal" "$fileManager" "$webbrowser" ] "")
          # -- Focus and movement --
          # change state
          (mkBindsParamed [ _mm _ms ] "F" [
            "fullscreen"
            "fullscreenstate, 0 2"
          ] "")
          (mkBinds _mm "V" "togglefloating" "" "")
          (mkBinds _ms "C" "${_layout}killactive" "" "")
          # navigation & move
          (mkBinds [ _mm _ms ] [ "H" "J" "K" "L" ]
            [ "${_layout}movefocus" "${_layout}movewindow" ]
            [ "l" "d" "u" "r" ]
            ""
          )
          (mkBinds _mm [ "mouse:272" "mouse:273" ] [ "movewindow" "resizewindow" ] "" "m")
          # monitor
          (mkBinds _mm [ "bracketleft" "bracketright" ] "focusmonitor" [
            "l"
            "r"
          ] "")
          # no _layout prefix, as hy3 does not seem to support inter-monitor movement
          (mkBinds _ms [ "bracketleft" "bracketright" ] "movewindow" [
            "mon:l"
            "mon:r"
          ] "")
          # workspace
          (mkNumBinds _mm (i: "${_ws}workspace, ${toString i}") "")
          (mkNumBinds _ms (i: "${_layout}movetoworkspace, ${toString i}") "")
          (mkBinds _ms [ "mouse_down" "mouse_up" ] "${_ws}workspace" [ "r+1" "r-1" ] "")
          # special Workspace
          (mkBinds _mm "X" "togglespecialworkspace" "magic" "")
          (mkBinds _ms "X" "${_layout}movetoworkspace" "special:magic" "")
        ])
        (mkSubmap "resize" [
          (mkBinds "" [ "H" "J" "K" "L" ] "resizeactive" [
            "-15 0"
            "0 15"
            "0 -15"
            "15 0"
          ] "e")
          (mkBinds "SHIFT" [ "H" "J" "K" "L" ] "${_layout}movefocus" [
            "l"
            "d"
            "u"
            "r"
          ] "")
          (mkBinds "" "escape" "submap" "global" "")
        ])
        (mkSubmap "global" [
          (mkBinds _ms "R" "submap" "resize" "")
        ])
        # --- Misc Utilities ---
        (mkSubmap "global" [
          (mkBinds "" [ "XF86AudioRaiseVolume" "XF86AudioLowerVolume" "XF86AudioMute" "XF86AudioMicMute" ]
            "exec"
            [
              "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
              "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
              "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ]
            "el"
          )
        ])

        # --- Caelestia Integration ---
        (mkIf config.programs.caelestia.enable (
          mkSubmap "global" [
            (mkBinds _mm [ "R" "P" ] "global" [
              "caelestia:launcher"
              "caelestia:showall"
            ] "")
            (mkBinds _ms "S" "exec" "caelestia screenshot --region --freeze" "")
            # (mkBinds _ms "L" "global" "caelestia:lock" "")
            (mkBinds _ms "L" "exec" "caelestia shell -d" "l")
            # (mkBinds (_mm + "ALT") "L" "global" "caelestia:lock" "l")
            (mkBinds (_mm + "ALT") "L" "exec" "hyprlock" "l")
            (mkBinds _mm (
              builtins.genList (i: "mouse:" + toString (i + 272)) 6
              ++ [
                "catchall"
                "mouse_up"
                "mouse_down"
              ]
            ) "global" "caelestia:launcherInterrupt" "in")
            (mkBinds ""
              [
                "XF86MonBrightnessUp"
                "XF86MonBrightnessDown"
                "XF86AudioPlay"
                "XF86AudioPause"
                "XF86AudioNext"
                "XF86AudioPrev"
                "XF86AudioStop"
              ]
              "global"
              [
                "caelestia:brightnessUp"
                "caelestia:brightnessDown"
                "caelestia:mediaToggle"
                "caelestia:mediaToggle"
                "caelestia:mediaNext"
                "caelestia:mediaPrev"
                "caelestia:mediaStop"
              ]
              "l"
            )
          ]
        ))

        # --- hy3 ---
        (mkIf cfg.plugin.hy3 (
          mkSubmap "global" [
            (mkBinds _mm "T" "hy3:changegroup" "toggletab" "")
            (mkBinds [
              _mm
              (_mm + "CTRL")
            ] "S" "hy3:makegroup" [ "v" "h" ] "")
          ]
        ))
      ];
  };
}
