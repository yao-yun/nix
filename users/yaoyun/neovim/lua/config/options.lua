-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- I like Tabs !
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Hyprlang tree-sitter
vim.filetype.add({
	pattern = {
		[".*/hypr/.*%.conf"] = "hyprlang",
		[".*/hyprland.d/.*%.conf"] = "hyprlang",
	},
})

-- neotree netrw hijacking
vim.api.nvim_create_autocmd("BufNewFile", {
	group = vim.api.nvim_create_augroup("RemoteFile", { clear = true }),
	callback = function()
		local f = vim.fn.expand("%:p")
		for _, v in ipairs({ "sftp", "scp", "ssh", "dav", "fetch", "ftp", "http", "rcp", "rsync" }) do
			local p = v .. "://"
			if string.sub(f, 1, #p) == p then
				vim.cmd([[
          unlet g:loaded_netrw
          unlet g:loaded_netrwPlugin
          runtime! plugin/netrwPlugin.vim
          silent Explore %
        ]])
				vim.api.nvim_clear_autocmds({ group = "RemoteFile" })
				break
			end
		end
	end,
})
