{ lib, config, ... }:
let
  util = import ./util.nix;
  mm = "$mainMod";
  ms = mm + "+SHIFT";
  prefix = {
    layout = "";
    workspace = "";
  };
in
with lib;
with util;
{
  config = mkMerge [
    {
      wayland.windowManager.hyprland.settings = mergeBinds [
        # shortcuts
        (mkBinds mm [ "Q" "E" ] "exec" [ "$terminal" "$fileManager" ] "")
        # -- Focus and movement --
        # change state
        (mkBindsParamed [ mm ms ] "F" [
          "fullscreen"
          "fullscreenstate, 0 2"
        ] "")
        (mkBinds ms "C" "killactive" "" "")
        # navigation
        (mkBinds [ mm ms ] [ "H" "J" "K" "L" ]
          [ "${prefix.layout}movefocus" "${prefix.layout}movewindow" ]
          [ "l" "u" "d" "r" ]
          ""
        )
        # monitor
        (mkBinds mm [ "bracketleft" "bracketright" ] "focusmonitor" [
          "l"
          "r"
        ] "")
        (mkBinds ms [ "bracketleft" "bracketright" ] "movewindow" [
          "mon:l"
          "mon:r"
        ] "")
        # workspace
        (mkNumBinds mm (i: "${prefix.workspace}workspace, ${toString i}") "")
        (mkNumBinds ms (i: "${prefix.layout}movetoworkspace, ${toString i}") "")
        (mkBinds ms [ "mouse_down" "mouse_up" ] "${prefix.workspace}workspace" [ "r+1" "r-1" ] "")
        # special Workspace
        (mkBinds mm "X" "togglespecialworkspace" "magic" "")
        (mkBinds ms "X" "movetoworkspace" "special:magic" "")
      ];
    }
    (mkIf config.programs.caelestia.enable {
      wayland.windowManager.hyprland.settings = mkSubmap "global" "" "escape" [
        (mkBinds mm [ mm "L" "P" ] "global" [
          "caelestia:launcher"
          "caelestia:lock"
          "caelestia:showall"
        ] "")
        (mkBinds ms "L" "exec" "caelestia shell -d" "l")
        (mkBinds ms "L" "global" "caelestia:lock" "l")
        (mkBinds mm (
          builtins.genList (i: "mouse:" + toString (i + 272)) 6
          ++ [
            "catchall"
            "mouse_up"
            "mouse_down"
          ]
        ) "global" "caelestia:launcherInterrupt" "in")
      ];
    })
  ];
}

# bind =
#   let
#     prefix = {
#       layout = "";
#       workspace = "";
#     };
#   in
#   lib.lists.flatten [
#     # shortcuts
#     "$mainMod, Q, exec, $terminal"
#     "$mainMod, E, exec, $fileManager"
#     # -- Window --
#     # manipulation
#     (mkBindwithMod "$mainMod" [
#       "V, togglefloating"
#       "F, fullscreen"
#     ])
#     (mkBindwithMod "$mainMod+SHIFT" [
#       "C, killactive"
#       "F, fullscreenstate, 0 2"
#       "H, ${prefix.layout}movewindow, l"
#       "J, ${prefix.layout}movewindow, u"
#       "K, ${prefix.layout}movewindow, d"
#       "L, ${prefix.layout}movewindow, r"
#       "bracketleft, movewindow, mon:l"
#       "bracketright, movewindow, mon:r"
#     ])
#     # navigation
#     (mkBindwithMod "$mainMod" [
#       "H, ${prefix.layout}movefocus, l"
#       "J, ${prefix.layout}movefocus, u"
#       "K, ${prefix.layout}movefocus, d"
#       "L, ${prefix.layout}movefocus, r"
#       "bracketleft, focusmonitor, l"
#       "bracketright, focusmonitor, r"
#     ])
#     # -- Workspace --
#     (mkNumBind "$mainMod SHIFT" (i: "${prefix.layout}movetoworkspace, ${toString i}") { })
#     (mkNumBind "$mainMod" (i: "${prefix.workspace}workspace, ${toString i}") { })
#     "$mainMod, x, togglespecialworkspace, magic"
#     (mkBindwithMod "$mainMod SHIFT" [
#       "x, ${prefix.layout}movetoworkspace, special:magic"
#       "mouse_down, ${prefix.workspace}workspace, r+1"
#       "mouse_up, ${prefix.workspace}workspace, r-1"
#     ])
#     # -- caelestia integration --
#     (
#       if config.programs.caelestia.enable then
#         [
#           (mkBindwithMod "$mainMod" [
#             "R, global, caelestia:launcher"
#           ])
#           (mkBindwithMod "$mainMod+SHIFT" [
#             "L, global, caelestia:launcher"
#           ])
#         ]
#       else
#         [ ]
#     )
#   ];
# };

# my idea
# A -> B
# A = [
#   mkBind "SUPER+ALT" "K" "exec, kitty" "e"
#   mkBindwithMod "SUPER" [
#       "C", "closeactivewindow", "in"
#       "W", "exec, firefox", "e"
#   ]
# ]
# Then B = {
#   binde = [
#       "SUPER+ALT,K,exec,kitty"
#       "SUPER,K,exec,firefox"
#   ];
#   bindin = [
#       "SUPER,C,closeactivewindow"
#   ]
# }
