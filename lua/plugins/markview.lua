vim.api.nvim_create_autocmd("FileType", {
	pattern = "codecompanion",
	command = "Markview attach",
})

return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	opts = {
		preview = {
			icon_provider = "devicons",
			filetypes = {
				-- "markdown",
			},
		},
	},
}
