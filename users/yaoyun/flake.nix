{
  description = "My home manager configuration with external home modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    # Add the flake that provides the home module
    my-nixcats.url = "path:./neovim-nixcats";
  };

  outputs = { self, nixpkgs, home-manager, my-nixcats }: {
    homeConfigurations = {
      "myusername" = home-manager.lib.homeManagerConfiguration {
        # Import the necessary modules
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        # Include the module from your flake
        modules = [
          my-nixcats.homeModules
          ./home.nix
        ];
      };
    };
  };
}

