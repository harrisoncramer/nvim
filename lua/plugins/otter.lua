return {
	"jmbuhr/otter.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
	config = function()
		local otter = require("otter")

		-- Activate otter for markdown files with embedded code
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown" },
			callback = function()
				otter.activate({
					"javascript",
					"typescript",
					"lua",
					"bash",
					"go",
				})
			end,
		})
	end,
}
