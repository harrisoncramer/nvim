local u = require("functions.utils")

-- https://stackoverflow.com/a/63908546/2338672
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
	pattern = "*",
	callback = function()
		vim.wo.winbar = ""
	end,
})

local preview_keys = {
	-- ["<Esc>"] = { "", mode = { "n", "x" } },
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
	--["<Esc>"] = { "", mode = { "n", "x" } },
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
			"<C-k>",
			function()
				require("snacks").picker.projects({
					finder = "recent_projects",
					patterns = { ".git", "package.json" },
					recent = true,
					matcher = {
						frecency = true, -- use frecency boosting
						sort_empty = true, -- sort even when the filter is empty
						cwd_bonus = false,
					},
					sort = { fields = { "score:desc", "idx" } },
					win = {
						preview = { minimal = true },
						input = {
							keys = {
								-- every action will always first change the cwd of the current tabpage to the project
								["<c-e>"] = { { "tcd", "picker_explorer" }, mode = { "n", "i" } },
								["<c-j>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } },
								["<c-f>"] = { { "tcd", "picker_grep" }, mode = { "n", "i" } },
								["<c-r>"] = { { "tcd", "picker_recent" }, mode = { "n", "i" } },
								["<c-w>"] = { { "tcd" }, mode = { "n", "i" } },
								["<c-t>"] = {
									function(picker)
										vim.cmd("tabnew")
										Snacks.notify("New tab opened")
										picker:close()
										Snacks.picker.projects()
									end,
									mode = { "n", "i" },
								},
							},
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
				require("snacks").picker.command_history({
					title = "Search Files",
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
			end,
			mode = { "n" },
			desc = "Find Git Files",
		},
		{
			"<C-z>",
			mode = { "n", "t" },
			function()
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
				-- require("snacks").picker(require("snacks").terminal.list())
				-- require("snacks").terminal.toggle()
			end,
			desc = "Toggle Terminal",
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
