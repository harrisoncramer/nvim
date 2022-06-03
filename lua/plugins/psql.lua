-- Password is hard-coded in the plugin for now to "postgres"
return {
	set_keybindings = function()
		local psql = require("psql")
		local map_opts = { noremap = true, silent = true, nowait = true }
		vim.keymap.set("n", "<localleader>r", psql.query_paragraph, map_opts)
		vim.keymap.set("n", "<localleader>e", psql.query_current_line, map_opts)
		vim.keymap.set("v", "<localleader>e", psql.query_selection, map_opts)
		vim.cmd([[ autocmd FileType sql lua require("plugins.psql").createMappings() ]])
	end,
}
