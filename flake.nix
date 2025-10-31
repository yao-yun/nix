{
  description = "Yaoyun's test NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yaoyun = {
      url = "path:./users/yaoyun/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      yaoyun,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          stylix.nixosModules.stylix
          ./configuration.nix

          # configure user
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
            }
          )

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hmbak";

              users.yaoyun = ./users/yaoyun/home.nix;

              extraSpecialArgs = {
                inputs = inputs // yaoyun.inputs;
              };
            };

          }
        ];
      };

      inherit (yaoyun) homeConfigurations;
    };
}
