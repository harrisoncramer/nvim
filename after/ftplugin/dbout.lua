local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }

vim.keymap.set("n", "<C-k>", "<Plug>(DBUI_JumpToForeignKey)", map_opts)

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "dbout" },
	callback = function()
		vim.opt.foldenable = false
	end,
})
