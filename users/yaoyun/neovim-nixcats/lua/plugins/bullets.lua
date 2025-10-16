return {
	"bullets-vim/bullets.vim",
	ft = "markdown",
	lazy = true,
	config = function()
		vim.g.bullets_checkbox_markers = " .oOx"
	end,
	keys = {
		{ "<leader>t", "<cmd>ToggleCheckbox<cr>", desc = "Toggle checkboxes" },
	},
}
