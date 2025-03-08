vim.keymap.set(
	"n",
	"<C-k>",
	"<Plug>(DBUI_JumpToForeignKey)",
	merge(local_keymap_opts, { desc = "Jump to foreign key" })
)

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "dbout" },
	callback = function()
		vim.opt.foldenable = false
	end,
})
