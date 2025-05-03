return {
	"smoka7/hop.nvim",
	version = "*",
	opts = {
		keys = "etovxqpdygfblzhckisuran",
	},
	config = function()
		local hop = require("hop")
		hop.setup()
		vim.keymap.set("n", "F", ":HopWordMW<CR>")
	end,
}
