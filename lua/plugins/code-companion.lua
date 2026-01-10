vim.keymap.set("n", "<C-a><C-r>", function()
	require("git-helpers").branch_input(function(branch)
		require("git-helpers.review").review_changes(branch)
	end)
end, merge(global_keymap_opts, { desc = "Send diff of current branch to code companion" }))

local anthropic_config = function()
	local anthropicApiKey = os.getenv("ANTHROPIC_API_KEY")
	return require("codecompanion.adapters").extend("claude_code", {
		env = {
			ANTHROPIC_API_KEY = anthropicApiKey,
		},
	})
end

return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/codecompanion-history.nvim",
	},
	opts = {
		-- There are two "types" of adapter in CodeCompanion; http adapters which connect you to an LLM and ACP adapters which leverage the Agent Client Protocol to connect you to an agent.
		-- The configuration for both types of adapters is exactly the same, however they sit within their own tables (adapters.http.* and adapters.acp.*) and have different options available. HTTP adapters use models to allow users to select the specific LLM they'd like to interact with. ACP adapters use commands to allow users to customize their interaction with agents (e.g. enabling yolo mode).
		adapters = {
			acp = {
				claude_code = anthropic_config,
			},
			http = {
				anthropic = anthropic_config,
			},
		},
		-- This sets the default adapter for the ACP to be claude code.
		interactions = {
			chat = {
				adapter = "claude_code",
			},
		},
		rules = {
			default = {
				enabled = true,
				description = "Collection of common files for all projects",
				files = {
					"~/.config/nvim/.ai/rules",
				},
			},
			opts = {
				chat = {
					enabled = true,
					autoload = "default",
				},
			},
		},
		display = {
			chat = {
				fold_reasoning = false,
				show_reasoning = true,
			},
			diff = {
				enabled = true,
				layout = "vertical",
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
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
					auto_generate_title = false,
					dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
				},
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
			adapter = "anthropic",
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
			"<cmd>CodeCompanionChat adapter=claude_code Toggle<cr>",
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
