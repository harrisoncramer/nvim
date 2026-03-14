vim.api.nvim_create_autocmd("FileType", {
	pattern = "codecompanion",
	command = "Markview attach",
})

vim.keymap.set("n", "<localleader>r", "<cmd>Markview toggle<cr>", { desc = "Toggle markview" })

return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	opts = {
		preview = {
			icon_provider = "devicons",
			filetypes = {
				"markdown",
			},
		},
	},
}
