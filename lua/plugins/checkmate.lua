return {
	"bngarren/checkmate.nvim",
	ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
	opts = {
		keys = {
			["<leader>tt"] = "toggle", -- Toggle todo item
			-- ["<leader>tc"] = "check", -- Set todo item as checked (done)
			-- ["<leader>tu"] = "uncheck", -- Set todo item as unchecked (not done)
			["<leader>tn"] = "create", -- Create todo item
			["<leader>tR"] = "remove_all_metadata", -- Remove all metadata from a todo item
			["<leader>ta"] = "archive", -- Archive checked/completed todo items (move to bottom section)
		},
	},
}
