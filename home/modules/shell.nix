{ pkgs, inputs, ... }:
{
  imports = [
    # inputs.nixCats.home
  ];

  home.packages = with pkgs; [
    # utilities
    btop
    bat
    dust
    tlrc
    btop
    fzf
    yazi
    fastfetch
    # utils
    rink
    # compression
    p7zip
    zip
    unzip
    gnutar
    gzip
    xz
    # web / network
    curl
    nmap
  ];

  programs = {
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = "Yaoyun Zhang";
          email = "yaoyun_zhang@outlook.com";
        };
      };
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
      };
    };
    fish = {
      enable = true;
      loginShellInit = ''
        fish_add_path ~/.nix-profile/bin
      '';
      interactiveShellInit = ''
        set fish_greeting # disable greeting
        # fenv source "~/.nix-profile/etc/profile.d/hm-session-vars.sh" > /dev/null
      '';
      plugins =
        builtins.map
          (pluginName: {
            name = pluginName;
            src = pkgs.fishPlugins.${pluginName}.src;
          })
          [
            "foreign-env"
            "tide"
            "sponge"
            "pisces"
            "done"
            "colored-man-pages"
            "foreign-env"
          ];
    };
    zoxide.enable = true;
  };
}
