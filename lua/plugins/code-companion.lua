return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"banjo/contextfiles.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/codecompanion-history.nvim",
	},
	opts = {
		display = {
			diff = {
				enabled = true,
				layout = "vertical",
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "default",
			},
		},
		extensions = {
			history = {
				enabled = true,
				opts = {
					-- Keymap to open history from chat buffer (default: gh)
					keymap = "<C-a><C-h>",
					auto_save = true,
					expiration_days = 0,
					picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
					chat_filter = nil, -- function(chat_data) return boolean end
					picker_keymaps = {
						rename = { n = "r", i = "<M-r>" },
						delete = { n = "d", i = "<M-d>" },
						duplicate = { n = "<C-y>", i = "<C-y>" },
					},
					auto_generate_title = true,
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				},
			},
		},
		adapters = {
			http = {
				anthropic = function()
					local anthropicApiKey = os.getenv("ANTHROPIC_API_KEY")
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
							api_key = anthropicApiKey,
						},
					})
				end,
				llama3 = function()
					return require("codecompanion.adapters").extend("ollama", {
						schema = {
							env = {
								url = "http://localhost:11434",
							},
							model = {
								default = "codellama",
							},
						},
					})
				end,
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
				adapter = "llama3",
				roles = {
					llm = "CodeCompanion",
					user = "Code Companion Chat",
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
							n = "<esc>",
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
			"<C-a><C-a>",
			"<cmd>CodeCompanionChat Toggle<cr>",
			mode = { "n", "v" },
			noremap = true,
			silent = true,
			desc = "CodeCompanion chat",
		},
		{
			"<C-a><C-h>",
			"<cmd>CodeCompanionHistory<cr>",
			mode = { "n", "v" },
			noremap = true,
			silent = true,
			desc = "CodeCompanion history",
		},
	},
}
