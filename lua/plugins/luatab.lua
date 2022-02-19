vim.keymap.set("n", "<leader>tn", ":tabnext<CR>")
vim.keymap.set("n", "<leader>tp", ":tabprev<CR>")
vim.keymap.set("n", "<leader>tc", ":tabclose<CR> | :tabprev<CR>")
require("luatab").setup({
	separator = function()
		return ""
	end,
})
