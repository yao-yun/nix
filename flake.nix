{
	description = "Yaoyun's test NixOS flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
                yaoyunHomeFlake = {
                        url = "path:./users/yaoyun/";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
		# nixvim = {
		# 	url = "github:nix-community/nixvim/nixos-25.05";
		# 	inputs.nixpkgs.follows = "nixpkgs";
		# };
	};

	outputs = { self, nixpkgs, home-manager, ...}@inputs: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			modules = [
				./configuration.nix

                # networking
                (
                    { ... }: {
                            networking = {
                                    hostName = "nixos";
                                    wireless.iwd.enable = true;
                                    networkmanager.enable = true; 
                                    networkmanager.wifi.backend = "iwd";
                                };
                        }
                )

                # configure user
				( 
					{ pkgs, ... }: {
						users.users.yaoyun = {
							isNormalUser = true;
							home = "/home/yaoyun";
							shell = pkgs.fish;
							extraGroups = [ "NetworkManager" "wheel" ];
						};
						programs.fish.enable = true;
					}	
				)

				# basic and accustomed sysadmin tools for me
				(	
					{ pkgs, ... }: {
						environment.systemPackages = with pkgs; [
							(lib.hiPrio uutils-coreutils-noprefix) # see https://wiki.nixos.org/wiki/Uutils
							# network 
							iproute2
							# editing
							vim
							# misc
							file
						];
                        # ssh 
                        services.openssh = {
                                enable = true; 
                                settings = {
                                    PermitRootLogin = "no";
                                    PasswordAuthentication = true;
                                };
                                openFirewall = true;
                            };
                        # pipewire with rtkit
                        security.rtkit.enable = true;
                        services.pipewire = {
                            enable = true; 
                            alsa.enable = true;
                            alsa.support32Bit = true;
                            pulse.enable = true;
                        };
					}
				)
				
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						backupFileExtension = "hmbak";
						
						# import user's configs
						users.yaoyun = import ./users/yaoyun/home.nix;
					};
				}
			];
		};
	};
}
