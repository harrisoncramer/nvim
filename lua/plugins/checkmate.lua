return {
	"bngarren/checkmate.nvim",
	ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
	files = {
		"*",
	},
	opts = {
		keys = {
			["<leader>tt"] = {
				rhs = "<cmd>Checkmate toggle<CR>",
				desc = "Toggle todo item",
				modes = { "n", "v" },
			},
			["<leader>tn"] = {
				rhs = "<cmd>Checkmate create<CR>",
				desc = "Create todo item",
				modes = { "n", "v" },
			},
			["<leader>ta"] = {
				rhs = "<cmd>Checkmate archive<CR>",
				desc = "Archive checked/completed todo items (move to bottom section)",
				modes = { "n" },
			},
		},
	},
}
