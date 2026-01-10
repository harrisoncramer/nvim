-- Send Diff to CodeCompanion and have it review the changes.
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
	lazy = false,
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
			inline = {
				adapter = "anthropic",
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
					auto_save = true,
					expiration_days = 0,
					picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
					chat_filter = nil, -- function(chat_data) return boolean end
					picker_keymaps = {
						rename = { n = "r", i = "<M-r>" },
						delete = { n = "d", i = "<M-d>" },
						duplicate = { n = "<C-y>", i = "<C-y>" },
					},
					auto_generate_title = false, -- Does not work in ACP/Agentic mode
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
	},
	keys = {
		{
			-- Toggles the chat window
			"<C-a><C-a>",
			"<cmd>CodeCompanionChat adapter=claude_code Toggle<cr>",
			mode = { "n", "v" },
			noremap = true,
			silent = true,
			desc = "CodeCompanion chat",
		},
		{
			-- Opens hisotry of previous chats
			"<C-a><C-h>",
			"<cmd>CodeCompanionHistory<cr>",
			mode = { "n", "v" },
			noremap = true,
			silent = true,
			desc = "CodeCompanion history",
		},
		-- Key mapping for visual mode: Prompts the user for input, then runs the CodeCompanion command on the visually selected lines with the given input
		{
			"<C-a>r",
			function()
				vim.ui.input({ prompt = "Prompt:" }, function(input)
					if input then
						vim.cmd("'<,'>CodeCompanion " .. input)
					end
				end)
			end,
			mode = "v",
			noremap = true,
			silent = true,
			desc = "CodeCompanion prompt to update/rework/refactor some visual selection.",
		},
	},
}
