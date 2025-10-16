return {
	{
		"folke/tokyonight.nvim",
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
			},
		},
	},
	{
		"kepano/flexoki-neovim",
		name = "flexoki",
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
			},
		},
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			set_dark_mode = function()
				vim.cmd([[ colorscheme carbonfox ]])
			end,
			set_light_mode = function()
				vim.cmd([[ colorscheme dayfox ]])
			end,
		},
	},
	{ "edeneast/nightfox.nvim", opts = {
		transparent = true,
	} }, -- lazy
}
