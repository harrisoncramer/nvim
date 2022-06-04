-- Password is hard-coded in the plugin for now to "postgres"
return {
	setup = function()
		local psql = require("psql")
		psql.setup({})
	end,
	set_keybindings = function()
		local psql = require("psql")
		local map_opts = { noremap = true, silent = true, nowait = true }
		vim.keymap.set("n", "<localleader>r", psql.query_paragraph, map_opts)
		vim.keymap.set("n", "<localleader>e", psql.query_current_line, map_opts)
		vim.keymap.set("n", "<localleader>y", psql.yank_cell, map_opts)
		vim.keymap.set("v", "<localleader>e", psql.query_selection, map_opts)
	end,
}
