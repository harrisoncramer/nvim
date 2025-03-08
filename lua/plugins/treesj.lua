return {
	"Wansmer/treesj",
	keys = { "<leader>jt", "<leader>jj", "<leader>je" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local treesj = require("treesj")
		treesj.setup({ use_default_keymaps = false, max_join_length = 1000 })
		vim.keymap.set("n", "<leader>jj", treesj.toggle, merge(global_keymap_opts, { desc = "Toggle treesitter join" }))
	end,
}
