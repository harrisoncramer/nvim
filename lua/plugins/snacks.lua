local u = require("functions.utils")

local preview_keys = {
	["<Esc>"] = { "", mode = { "n", "x" } },
	["sh"] = { "toggle_focus", mode = { "n", "x" } },
}

local list_keys = {
	["<Esc>"] = { "", mode = { "n", "x" } },
	["/"] = "toggle_focus",
	["sp"] = { "focus_preview", mode = { "n", "x" } },
}

local input_keys = {
	["<Esc>"] = { "", mode = { "n", "x" } },
	["sl"] = { "focus_preview", mode = { "n", "x" } },
	["/"] = { "toggle_focus", mode = { "i", "n", "x" } },
	["<c-q>"] = { "qflist", mode = { "i", "n", "x" } },
	["<c-s>"] = "edit_split",
	["<c-v>"] = "edit_vsplit",
	["<c-t>"] = "tab",
	["<CR>"] = "confirm",
	["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
	["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
	["<C-o>"] = { "select_all", mode = { "n", "i", "x" } },
	["G"] = "list_bottom",
	["gg"] = "list_top",
	-- ["<c-u>"] = { "preview_scroll_up", mode = { "n", "i" } },
	-- ["<c-d>"] = { "preview_scroll_down", mode = { "n", "i" } },
	["?"] = "toggle_help_list",
	["j"] = "list_down",
	["k"] = "list_up",
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<C-j>",
			function()
				require("snacks").picker.git_files({
					title = "Search Files",
					win = {
						preview = {
							keys = preview_keys,
						},
						list = {
							keys = list_keys,
						},
						input = {
							keys = u.merge(input_keys, {
								["<C-j>"] = { "close", mode = { "n", "i" } },
							}),
						},
					},
				})
			end,
			mode = { "n" },
			desc = "Find Git Files",
		},
		{
			"<C-m>",
			function()
				require("snacks").picker.git_files({
					cwd = "~/.config/nvim",
					title = "Neovim Config",
					win = {
						preview = {
							keys = preview_keys,
						},
						list = {
							keys = list_keys,
						},
						input = {
							keys = u.merge(input_keys, {
								["<C-m>"] = { "close", mode = { "n", "i" } },
							}),
						},
					},
				})
			end,
			mode = { "n" },
			desc = "Neovim Files",
		},
		{
			"<C-f>",
			function()
				require("snacks").picker.grep({
					title = "Search Text",
					live = true,
					win = {
						preview = {
							keys = preview_keys,
						},
						list = {
							keys = list_keys,
						},
						input = {
							keys = u.merge(input_keys, {
								["<C-f>"] = { "close", mode = { "n", "i" } },
							}),
						},
					},
				})
			end,
			mode = { "n" },
			desc = "Search text",
		},
		{
			"<C-c>",
			function()
				require("snacks").picker.command_history(u.merge({}, {
					title = "Search Command History",
					layout = {
						layout = { position = "bottom" },
					},
					win = {
						preview = {
							keys = preview_keys,
						},
						list = {
							keys = list_keys,
						},
						input = {
							keys = u.merge(input_keys, {
								["<C-c>"] = { "close", mode = { "n", "i" } },
								["<Enter>"] = { "pick", mode = { "n", "i" } },
							}),
						},
					},
				}))
			end,
			mode = { "n" },
			desc = "Search Command History",
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
