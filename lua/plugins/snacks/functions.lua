local Projects = require("plugins.snacks.projects")
local ChangedFiles = require("plugins.snacks.changed-files")
local auto_save = require("plugins.bqf.auto-save")
local projects = Projects.new()
local changed_files = ChangedFiles.new("staging")

local M = {}

local excludes = {
	"**/.qf/**",
	"**/db/models/**",
	"**/__evq/**",
	"**/__delta/**",
	"**/chariot-shared/jet/**",
	"**/gen/**",
}

local function get_search_query(picker)
	if picker.input and picker.input:get() then
		return picker.input:get()
	end

	if picker.opts and picker.opts.search then
		if type(picker.opts.search) == "function" then
			return picker.opts.search(picker) or ""
		else
			return picker.opts.search or ""
		end
	end

	return ""
end

M.preview_keys = {
	["sk"] = { "toggle_focus", mode = { "n", "x" } },
	["<CR>"] = { "confirm", mode = { "n", "i", "x" } },
}

M.list_keys = {
	["<Esc>"] = { "", mode = { "n", "x" } },
	["<C-s>"] = "toggle_focus",
	["sp"] = { "focus_preview", mode = { "n", "x" } },
	["<CR>"] = { "confirm", mode = { "n", "i", "x" } },
}

M.input_keys = {
	["<C-j>"] = { "history_forward", mode = { "i", "n" } },
	["<C-k>"] = { "history_back", mode = { "i", "n" } },
	["<CR>"] = { "confirm", mode = { "n", "i", "x" } },
	["sj"] = { "focus_preview", mode = { "n", "x" } },
	["<c-q>"] = { "qflist", mode = { "i", "n", "x" } },
	["<c-t>"] = { "edit_tab", mode = { "i" } },
	["<S-Tab>"] = { "select_and_prev", mode = { "n", "x", "i" } },
	["<Tab>"] = { "select_and_next", mode = { "n", "x", "i" } },
	["<C-o>"] = { "select_all", mode = { "n", "i", "x" } },
	["G"] = "list_bottom",
	["gg"] = "list_top",
	["?"] = "toggle_help_list",
	["j"] = "list_down",
	["k"] = "list_up",
}

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
				keys = merge(M.input_keys, directory_search_keys),
			},
		},
	})
end

M.git_files = function(opts)
	opts = opts or {}
	require("snacks").picker.files({
		cwd = opts.cwd,
		title = "Search Files",
		actions = {
			qflist = function(picker)
				require("snacks").picker.actions.qflist(picker)
				local search_query = get_search_query(picker) or "git_files"
				auto_save.auto_save_quickfix(search_query)
			end,
		},
		hidden = true,
		ignored = true,
		exclude = {
			"**/models/**",
			"**/gen/**",
			"**/node_modules/**",
			"**/.qf/**",
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
				keys = M.input_keys,
			},
		},
	})
end

M.find_text = function(opts)
	opts = opts or {}
	require("snacks").picker.grep({
		search = opts.search or "",
		exclude = excludes,
		cwd = opts.cwd,
		title = opts.cwd and string.format("Search Text in %s", opts.cwd) or "Search Text",
		live = true,
		submodules = true,
		actions = {
			qflist = function(picker)
				require("snacks").picker.actions.qflist(picker)
				local search_query = get_search_query(picker) or "grep_results"
				auto_save.auto_save_quickfix(search_query)
			end,
		},
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
				keys = M.input_keys,
			},
		},
	})
end

M.recent_files = function(opts)
	opts = opts or {}
	require("snacks").picker.recent({
		title = "Recent Files",
		cwd = opts.cwd,
		actions = {
			qflist = function(picker)
				require("snacks").picker.actions.qflist(picker)
				local search_query = get_search_query(picker) or "recent_files"
				auto_save.auto_save_quickfix(search_query)
			end,
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
				keys = merge(M.input_keys),
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
