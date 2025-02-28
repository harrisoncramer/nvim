local u = require("functions.utils")

local M = {}

-- Remove winbar from terminal
-- https://stackoverflow.com/a/63908546/2338672
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
	pattern = "*",
	callback = function()
		vim.wo.winbar = ""
	end,
})

-- TODO: Set up file filter to search for particular files, then
-- be able to search for text within them

-- Set all projects up for project-specific search

local all_projects = {
	"~/chariot/chariot",
	"~/chariot/proto",
	"~/chariot/ops",
	"~/chariot/deploy",
	"~/chariot/chariot/apps/actor/",
	"~/chariot/chariot/apps/assets/",
	"~/chariot/chariot/apps/auth/",
	"~/chariot/chariot/apps/clerk/",
	"~/chariot/chariot/apps/cmd/",
	"~/chariot/chariot/apps/coauth/",
	"~/chariot/chariot/apps/compliance/",
	"~/chariot/chariot/apps/connect/",
	"~/chariot/chariot/apps/dafpay/",
	"~/chariot/chariot/apps/dashboard/",
	"~/chariot/chariot/apps/integrations/",
	"~/chariot/chariot/apps/nonprofitDashboard/",
	"~/chariot/chariot/apps/orchestration/",
	"~/chariot/chariot/apps/payments/",
	"~/chariot/chariot/apps/secretary/",
	"~/chariot/chariot/apps/sherlock/",
	"~/chariot/chariot/apps/supervisor/",
	"~/chariot/chariot/apps/token/",
	"~/chariot/chariot/packages",
	"~/.dotfiles",
	"~/.config/nvim",
}
M.project_items = {}
for _, v in ipairs(all_projects) do
	table.insert(M.project_items, {
		title = v,
		text = v,
		file = v,
	})
end

-- Basic keybindings across all picker views

local preview_keys = {
	["sh"] = { "toggle_focus", mode = { "n", "x" } },
	["<CR>"] = { "confirm", mode = { "n", "i", "x" } },
}

local list_keys = {
	["<Esc>"] = { "", mode = { "n", "x" } },
	["<C-s>"] = "toggle_focus",
	["sp"] = { "focus_preview", mode = { "n", "x" } },
	["<CR>"] = { "confirm", mode = { "n", "i", "x" } },
}

local input_keys = {
	["<CR>"] = { "confirm", mode = { "n", "i", "x" } },
	["sl"] = { "focus_preview", mode = { "n", "x" } },
	["<C-s>"] = { "toggle_focus", mode = { "i", "n", "x" } },
	["<c-q>"] = { "qflist", mode = { "i", "n", "x" } },
	["<c-s>"] = "edit_split",
	["<c-v>"] = "edit_vsplit",
	["<c-t>"] = "tab",
	["<S-Tab>"] = { "select_and_prev", mode = { "n", "x", "i" } },
	["<Tab>"] = { "select_and_next", mode = { "n", "x", "i" } },
	["<C-o>"] = { "select_all", mode = { "n", "i", "x" } },
	["G"] = "list_bottom",
	["gg"] = "list_top",
	["?"] = "toggle_help_list",
	["j"] = "list_down",
	["k"] = "list_up",
}

-- TODO: Add .env to searched files

M.choose_directory_for_search = function()
	local directory_search_keys = {
		["<C-j>"] = { "git_files", mode = { "n", "i" } },
		["<C-f>"] = { "find_text", mode = { "n", "i" } },
	}

	Snacks.picker.pick({
		source = "Search In Directory",
		items = M.project_items,
		preview = "directory",
		format = "file",
		actions = {
			git_files = function(val)
				local dirname = val.preview.item.file
				M.git_files({ cwd = dirname })
			end,
			find_text = function(val)
				local dirname = val.preview.item.file
				M.find_text({ cwd = dirname })
			end,
		},
		win = {
			preview = {
				keys = u.merge(preview_keys, directory_search_keys),
			},
			list = {
				keys = u.merge(list_keys, directory_search_keys),
			},
			input = {
				keys = u.merge(input_keys, { ["<C-k>"] = { "close", mode = { "n", "i" } } }, directory_search_keys),
			},
		},
	})
end

M.git_files = function(opts)
	opts = opts or {}
	require("snacks").picker.git_files({
		cwd = opts.cwd,
		title = "Search Files",
		formatters = {
			file = {
				filename_first = true,
			},
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
					["<C-j>"] = { "close", mode = { "n", "i" } },
				}),
			},
		},
	})
end

M.find_text = function(opts)
	opts = opts or {}
	require("snacks").picker.git_grep({
		cwd = opts.cwd,
		title = opts.cwd and string.format("Search Text in %s", opts.cwd) or "Search Text",
		live = true,
		submodules = true,
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
end

M.command_history = function()
	require("snacks").picker.command_history({
		title = "Command History",
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
				}),
			},
		},
	})
end

M.recent_files = function(opts)
	opts = opts or {}
	require("snacks").picker.recent({
		title = "Recent Files",
		cwd = opts.cwd,
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
end

M.toggle_terminal = function()
	require("snacks").terminal("zsh", {
		keys = {
			term_normal = {
				"<esc><esc>",
				function()
					return "<C-\\><C-n>"
				end,
				mode = "t",
				expr = true,
				desc = "Double escape to normal mode",
			},
		},
		win = {
			style = "terminal",
			relative = "editor",
			minimal = true,
			position = "bottom",
		},
	}, { desc = "Terminal" })
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<C-j>",
			M.git_files,
			mode = { "n" },
			desc = "Find Git Files",
		},
		{
			"<C-k>",
			M.choose_directory_for_search,
			mode = { "n" },
			desc = "Neovim Files",
		},
		{
			"<C-f>",
			M.find_text,
			mode = { "n" },
			desc = "Search text",
		},
		{
			"<C-c>",
			M.command_history,
			mode = { "n" },
			desc = "Find Git Files",
		},
		{
			"<C-z>",
			M.toggle_terminal,
			mode = { "n", "t" },
			desc = "Toggle Terminal",
		},
		{
			"<C-m>",
			M.recent_files,
			mode = { "n", "t" },
			desc = "Recent Files",
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
				wo = {},
				bo = {
					filetype = "snacks_terminal",
				},
				win = { style = "terminal" },
				enabled = true,
			},
		}
	end,
}
