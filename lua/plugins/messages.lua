vim.keymap.set("n", "<leader>m", ":Messages<CR>", merge(global_keymap_opts, { desc = "Show messages" }))

return {
	"AckslD/messages.nvim",
	opts = {
		prepare_buffer = function(opts)
			local buf = vim.api.nvim_create_buf(false, true)
			vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, desc = "Close messages" })
			return vim.api.nvim_open_win(buf, true, opts)
		end,
	},
}
