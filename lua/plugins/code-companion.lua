-- Send Diff to CodeCompanion and have it review the changes.
local anthropic_config = function()
	local anthropicApiKey = os.getenv("ANTHROPIC_API_KEY")
	return require("codecompanion.adapters").extend("claude_code", {
		env = {
			ANTHROPIC_API_KEY = anthropicApiKey,
		},
		defaults = {
			model = "opus",
		},
	})
end

-- This configuration is necessary because I want a mostly YOLO-style ACP, but want high configurability
-- in the types of commands that it should be able to run or not. This setup lets me allow most things by
-- default, but gate on specific commands

-- Add sensitive tasks to this table, wildcard matches
local sensitive_scripts = {
	"prod",
	"staging",
	"admin",
	"db",
	"email",
	"sms",
	"env",
	"github",
	"commit",
	"push",
	"rebase",
	"docker",
	"feature",
	-- Chariot-specific
	"grantmaker",
	"kube",
}

-- Add Lua patterns to this table to allow edits without confirmation. Typically, file edits are the only thing
-- that require permission checks, so I can keep track of what Claude is changing.
local auto_approve_edit_patterns = {
	"%.qf/claude$",
}

-- Check if a file path matches any auto-approve patterns
local function is_auto_approved_file(file_path)
	for _, pattern in ipairs(auto_approve_edit_patterns) do
		if file_path:match(pattern) then
			return true
		end
	end
	return false
end

-- Check if a bash command contains sensitive tasks
-- These are blocked regardless of current working directory
local function is_sensitive_bash_command(command)
	for _, task in ipairs(sensitive_scripts) do
		-- Use plain string find (not pattern matching) with the 4th arg = true
		if command:find(task, 1, true) then
			return true
		end
	end

	return false
end

-- Auto-approve all ACP requests except mcp__acp__Edit (unless file is in auto-approve list).
vim.api.nvim_create_autocmd("User", {
	pattern = "CodeCompanionChatAdapter",
	callback = function()
		local ok, req_perm = pcall(require, "codecompanion.interactions.chat.acp.request_permission")
		if ok and req_perm then
			local original_show = req_perm.show
			req_perm.show = function(chat, request)
				local tool_name = request.tool_call
					and request.tool_call._meta
					and request.tool_call._meta.claudeCode
					and request.tool_call._meta.claudeCode.toolName

				-- Check if this is an mcp__acp__Edit request
				if tool_name == "mcp__acp__Edit" then
					local file_path = request.tool_call.rawInput and request.tool_call.rawInput.file_path
					if file_path and not is_auto_approved_file(file_path) then
						return original_show(chat, request)
					end
				end

				-- Check if this is a Bash command with sensitive mise tasks
				if tool_name == "Bash" then
					local command = request.tool_call.rawInput and request.tool_call.rawInput.command
					if command and is_sensitive_bash_command(command) then
						return original_show(chat, request)
					end
				end

				-- Auto-approve everything else
				for _, opt in ipairs(request.options or {}) do
					if opt.kind and opt.kind:find("allow", 1, true) then
						return request.respond(opt.optionId, false)
					end
				end
				-- Fallback: reject if no allow option found
				return request.respond(nil, true)
			end
		end
	end,
})

vim.keymap.set("n", "<C-a><C-r>", function()
	require("git-helpers").branch_input(function(branch)
		require("claude").review_changes(branch)
	end)
end, merge(global_keymap_opts, { desc = "Send diff of current branch to code companion" }))

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
				model = "opus",
			},
			inline = {
				adapter = "anthropic",
				model = "haiku",
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
					["image"] = {
						opts = {
							dirs = { "~/Desktop/screenshots" },
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
