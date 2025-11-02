local Projects = require("plugins.snacks.projects")
local ChangedFiles = require("plugins.snacks.changed-files")
local projects = Projects.new()
local changed_files = ChangedFiles.new("staging") -- TODO: @harrisoncramer fix this branch on init

local M = {}

local excludes = {
	"**/db/models/**",
	"**/chariot-shared/jet/**",
	"**/gen/**",
}

M.preview_keys = {
	["sh"] = { "toggle_focus", mode = { "n", "x" } },
	["<CR>"] = { "confirm", mode = { "n", "i", "x" } },
}

M.list_keys = {
	["<Esc>"] = { "", mode = { "n", "x" } },
	["<C-s>"] = "toggle_focus",
	["sp"] = { "focus_preview", mode = { "n", "x" } },
	["<CR>"] = { "confirm", mode = { "n", "i", "x" } },
}

M.input_keys = {
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
		items = projects:formatted_projects(),
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
				keys = merge(M.preview_keys, directory_search_keys),
			},
			list = {
				keys = merge(M.list_keys, directory_search_keys),
			},
			input = {
				keys = merge(M.input_keys, { ["<C-k>"] = { "close", mode = { "n", "i" } } }, directory_search_keys),
			},
		},
	})
end

--- @class PickerOpts
--- @field cwd? string
--- @field search? string
--- @field extra_keys? table
--- @field actions? table

--- @param opts PickerOpts
M.git_files = function(opts)
	opts = opts or {}
	require("snacks").picker.files({
		cwd = opts.cwd,
		title = "Search Files",
		actions = opts.actions or {},
		hidden = true,
		ignored = true,
		exclude = {
			"**/models/**",
			"**/gen/**",
			"**/node_modules/**",
			"**/db_queries/**",
			"**/.next/**",
			"**/.turbo/**",
			".DS_Store",
			"**/logs/**",
			"**/.git/**",
			"**/dist/**",
			"**/build/**",
			"**/coverage/**",
			"**/.undo/**",
			"**/tmp/**",
			"**/vendor/**",
		},
		formatters = {
			file = {
				filename_first = true,
			},
		},
		win = {
			preview = {
				keys = M.preview_keys,
			},
			list = {
				keys = M.list_keys,
			},
			input = {
				keys = merge(M.input_keys, { ["<C-j>"] = { "close", mode = { "n", "i" } } }, opts.extra_keys or {}),
			},
		},
	})
end

--- @param opts PickerOpts
M.changed_files = function(opts)
	opts = opts or {}

	require("snacks").picker.pick({
		title = "Changed files",
		items = changed_files:formatted(),
		preview = "file",
		format = "file",
		formatters = {
			file = {
				filename_first = true,
			},
		},
		win = {
			preview = {
				keys = M.preview_keys,
			},
			list = {
				keys = M.list_keys,
			},
			input = {
				keys = merge(M.input_keys, { ["<C-h>"] = { "close", mode = { "n", "i" } } }, opts.extra_keys or {}),
			},
		},
	})
end

--- @param opts PickerOpts
M.find_text = function(opts)
	opts = opts or {}
	require("snacks").picker.grep({
		search = opts.search or "",
		exclude = excludes,
		cwd = opts.cwd,
		title = opts.cwd and string.format("Search Text in %s", opts.cwd) or "Search Text",
		live = true,
		submodules = true,
		formatters = {
			file = {
				filename_first = true,
			},
		},
		opts = {

			layout = {
				width = 1,
				height = 1,
			},
		},
		win = {
			preview = {
				keys = M.preview_keys,
			},
			list = {
				keys = M.list_keys,
			},
			input = {
				keys = merge(M.input_keys, {
					["<C-f>"] = { "close", mode = { "n", "i" } },
				}),
			},
		},
	})
end

--- @param opts PickerOpts
M.recent_files = function(opts)
	opts = opts or {}
	require("snacks").picker.recent({
		title = "Recent Files",
		cwd = opts.cwd,
		formatters = {
			file = {
				filename_first = true,
			},
		},
		win = {
			preview = {
				keys = M.preview_keys,
			},
			list = {
				keys = M.list_keys,
			},
			input = {
				keys = merge(M.input_keys, {
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

return M
