return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<C-j>",
			function()
				require("snacks").picker.git_files({
					win = {
						input = {
							keys = {
								["<C-u>"] = "preview_scroll_up",
								["<C-d>"] = "preview_scroll_down",
							},
						},
					},
				})
			end,
			mode = { "n" },
			desc = "Find Git Files",
		},
		{
			"<C-f>",
			function()
				require("snacks").picker.grep({
					layout = {
						position = "bottom",
					},
				})
			end,
			mode = { "n" },
			desc = "Search text",
		},
		{
			"<C-c>",
			function()
				require("snacks").picker.command_history()
			end,
			mode = { "n" },
			desc = "Search text",
		},
		{
			"<C-z>",
			mode = { "n", "t" },
			function()
				local current_dir = vim.fn.expand("%:p:h")
				if current_dir == "" or vim.fn.isdirectory(current_dir) == 0 then
					current_dir = vim.fn.getcwd()
				end

				local in_terminal = vim.bo.buftype == "terminal"
				if in_terminal then
					vim.cmd("hide")
				else
					require("snacks").terminal.toggle("zsh", {
						-- cwd = current_dir,
						env = {
							TERM = "xterm-256color",
						},
						title = "",
						win = {
							style = "terminal",
							relative = "editor",
							width = 0.83,
							height = 0.83,
						},
					})
				end
			end,
			desc = "Toggle ZSH Terminal",
		},
	},
	config = function()
		---@type snacks.Config
		return {
			image = { enabled = false },
			bigfile = { enabled = true },
			notifier = { enabled = true },
			gitbrowse = { enabled = true },
			picker = {
				enabled = true,
			},
			terminal = {
				bo = {
					filetype = "snacks_terminal",
				},
				win = { style = "terminal" },
				enabled = true,
			},
		}
	end,
}
