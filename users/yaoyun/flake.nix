{
  description = "Home Manager configuration of yaoyun";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # for pam-fix on Non-nixOS
    pam_shim.url = "github:Cu3PO42/pam_shim";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.51.0";
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.51.0";
      inputs.hyprland.follows = "hyprland";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit?ref=v0.51.0";
      inputs.hyprland.follows = "hyprland";
    };
    
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."yaoyun" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.stylix.homeModules.stylix
          ./home.nix
        ];
        extraSpecialArgs = { inherit inputs; };
      };
      nixosModules."yaoyun" = [
        inputs.stylix.nixosModules.stylix

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = false;
            useUserPackages = true;
            backupFileExtension = "hmbak";

            users.yaoyun = ./home.nix;

            extraSpecialArgs = {
              inherit inputs;
            };
          };
        }

        {
          imports = [
            ./nixos/steam.nix
            ./nixos/stylix.nix
          ];
        }

        (
          { pkgs, ... }:
          {
            users.users.yaoyun = {
              isNormalUser = true;
              home = "/home/yaoyun";
              shell = pkgs.fish;
              extraGroups = [
                "NetworkManager"
                "wheel"
              ];
              password = "changeme";
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpzFyoXVgbIDrdlyuG0qXAnmMh6TEINBvI/TD98NvNe openpgp:0x99234C74"
              ];
            };
            programs.fish.enable = true;

            i18n.extraLocales = [
              "en_US.UTF-8/UTF-8"
              "zh_CN.UTF-8/UTF-8"
            ];
          }
        )

      ];
    };
}
