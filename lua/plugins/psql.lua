-- Password is hard-coded in the plugin for now to "postgres"
local psql = require("psql")
return {
	createMappings = function()
		local map_opts = { noremap = true, silent = true, nowait = true }
		vim.keymap.set("n", "<localleader>r", psql.query_paragraph, map_opts)
		vim.keymap.set("n", "<localleader>e", psql.query_current_line, map_opts)
		vim.keymap.set("v", "<localleader>e", psql.query_selection, map_opts)
	end,
	setup = function()
		psql.setup({})
		vim.cmd([[ autocmd FileType sql lua require("plugins.psql").createMappings() ]])
	end,
}
