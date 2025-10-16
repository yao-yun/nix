return {
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"3rd/image.nvim",
	},
	{
		"goerz/jupytext.nvim",
		version = "0.2.0",
		opts = {}, -- see Options
	},
	{
		"lambdalisue/vim-suda",
	},
	{
		"ibhagwan/fzf-lua",
		opts = {
			files = {
				fd_opts = "--type f --strip-cwd-prefix --ignore-file .gitignore --hidden --follow",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			filesystem = {
				hijack_netrw_behavior = "open_current",
			},
		},
	},
	{
		"kkoomen/vim-doge",
	},
	{
		"xiyaowong/transparent.nvim",
	},
	{
		"keaising/im-select.nvim",
		lazy = false,
		opts = {
			default_im_select = "keyboard-us",
			default_command = "fcitx5-remote",
			set_default_events = { "insertleave", "cmdlineleave" },
			set_previous_events = { "insertenter" },
		},
	},
}
