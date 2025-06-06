local snack_functions = require("plugins.snacks.functions")

-- Remove winbar from terminal
-- https://stackoverflow.com/a/63908546/2338672
vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
	pattern = "*",
	callback = function()
		vim.wo.winbar = ""
	end,
})

vim.keymap.set("n", "gw", function()
	local word = vim.fn.expand("<cword>")
	require("plugins.snacks.functions").find_text({ search = word })
end, merge(global_keymap_opts, { desc = "Search word under cursor" }))

vim.keymap.set("n", "<leader>e", function()
	require("snacks").picker.icons({
		icon_sources = { "emoji" },
		finder = "icons",
		format = "icon",
		layout = { preset = "select" },
		confirm = "put",
	})
end, merge(global_keymap_opts, { desc = "Place emoji at current location" }))

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<C-j>",
			snack_functions.git_files,
			mode = { "n" },
			desc = "Find Git Files",
		},
		{
			"<C-k>",
			snack_functions.choose_directory_for_search,
			mode = { "n" },
			desc = "Neovim Files",
		},
		{
			"<C-f>",
			snack_functions.find_text,
			mode = { "n" },
			desc = "Search text",
		},
		{
			"<C-c>",
			snack_functions.command_history,
			mode = { "n" },
			desc = "Find Git Files",
		},
		{
			"<C-z>",
			snack_functions.toggle_terminal,
			mode = { "n", "t" },
			desc = "Toggle Terminal",
		},
		{
			"<C-m>",
			snack_functions.recent_files,
			mode = { "n" },
			desc = "Recent Files",
		},
		{
			"<C-l>",
			snack_functions.changed_files,
			mode = { "n" },
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
				exclude = {
					"node_modules",
					"gen",
				},
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
