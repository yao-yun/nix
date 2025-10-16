{ config, pkgs, ... }:

{
	home.stateVersion = "25.05";
	home.username = "yaoyun";
	home.homeDirectory = "/home/yaoyun";

    imports = [
        ./neovim
    ];

	home.packages = with pkgs; [
		zoxide
		btop
		bat
		curl
		git 
		dust
		rink
		tlrc
		btop
		nmap
		eza
		fzf
		p7zip
		gnutar
		yazi
		fastfetch
	];

	programs.git = {
		enable = true;
		userName = "Yaoyun Zhang";
		userEmail = "yaoyun_zhang@outlook.com";
	};

	programs.starship = {
		enable = true;
		settings = {
			add_newline = false;
		};
	};

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			set fish_greeting # disable greeting
			starship init fish | source
		'';
		plugins = [
			{ name = "bass"; src = pkgs.fishPlugins.tide.src;}
			{ name = "sponge"; src = pkgs.fishPlugins.sponge.src;}
			{ name = "pisces"; src = pkgs.fishPlugins.pisces.src;}
			{ name = "done"; src = pkgs.fishPlugins.done.src;}
			{ name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src;}
		];
	};

	# hyprland 
	programs.kitty.enable = true;
	wayland.windowManager.hyprland.enable = true;
	
	home.sessionVariables.NIXOS_OZONE_WL = "1";
	
}
