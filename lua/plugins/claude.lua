return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		port_range = { min = 10000, max = 65535 },
		auto_start = true,
		log_level = "info", -- "trace", "debug", "info", "warn", "error"
		terminal_cmd = "/Users/harrisoncramer/.local/bin/claude --dangerously-skip-permissions",
		-- 	-- For local installations: "~/.claude/local/claude"
		-- 	-- For native binary: use output from 'which claude'
		--
		-- Send/Focus Behavior
		-- When true, successful sends will focus the Claude terminal if already connected
		-- focus_after_send = false,

		-- Selection Tracking
		track_selection = true,
		visual_demotion_delay_ms = 50,

		-- Terminal Configuration
		terminal = {
			split_side = "right", -- "left" or "right"
			split_width_percentage = 0.30,
			-- provider = "snacks", -- "auto", "snacks", "native", "external", "none", or custom provider table
			auto_close = true,
			snacks_win_opts = {
				position = "bottom",
				height = 0.4,
				width = 1.0,
				border = "single",
			},

			-- Provider-specific options
			provider_opts = {
				-- Command for external terminal provider. Can be:
				-- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
				-- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
				-- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
				external_terminal_cmd = nil,
			},
		},
		-- Diff Integration
		diff_opts = {
			layout = "vertical", -- "vertical" or "horizontal"
			open_in_new_tab = false,
			keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
			hide_terminal_in_new_tab = false,
			-- on_new_file_reject = "keep_empty", -- "keep_empty" or "close_window"

			-- Legacy aliases (still supported):
			-- vertical_split = true,
			-- open_in_current_tab = true,
		},
	},
	keys = {
		{ "<C-a><C-a>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude", mode = { "n", "t" } },
		{ "<C-a>c", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude", mode = { "n", "t" } },
		-- { "<C-a>r", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{
			"a",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
