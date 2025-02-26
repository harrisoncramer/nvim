local multiplier = function(a, b, c)
	return a * b * c
end
return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		display = {
			diff = {
				enabled = true,
				layout = "vertical", -- vertical|horizontal split for default provider
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "default", -- default|mini_diff
			},
		},
		strategies = {
			chat = {
				slash_commands = {
					["file"] = {
						opts = {
							provider = "snacks",
						},
					},
					["buffer"] = {
						opts = {
							provider = "snacks",
						},
					},
				},
				adapter = "openai",
				roles = {
					llm = "CodeCompanion",
					user = "Me",
				},
				keymaps = {
					close = {
						modes = {
							n = "q",
						},
						index = 3,
						callback = "keymaps.close",
						description = "Close Chat",
					},
					stop = {
						modes = {
							n = "<C-c",
						},
						index = 4,
						callback = "keymaps.stop",
						description = "Stop Request",
					},
				},
			},
		},
		inline = {
			adapter = "openai",
			keymaps = {
				accept_change = {
					modes = { n = "ga" },
					description = "Accept the suggested change",
				},
				reject_change = {
					modes = { n = "gr" },
					description = "Reject the suggested change",
				},
			},
		},
	},
	keys = {
		{
			"<leader>ar",
			":'<,'>CodeCompanion openai /buffer ",
			mode = { "v" },
			noremap = true,
			silent = true,
			desc = "CodeCompanion actions",
		},
		{
			"<leader>ac",
			"<cmd>CodeCompanionActions<cr>",
			mode = { "n", "v" },
			noremap = true,
			silent = true,
			desc = "CodeCompanion actions",
		},
		{
			"<leader>aa",
			"<cmd>CodeCompanionChat Toggle<cr>",
			mode = { "n", "v" },
			noremap = true,
			silent = true,
			desc = "CodeCompanion chat",
		},
		{
			"<leader>ad",
			"<cmd>CodeCompanionChat Add<cr>",
			mode = "v",
			noremap = true,
			silent = true,
			desc = "CodeCompanion add to chat",
		},
	},
}
