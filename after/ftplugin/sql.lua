local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }

local psql_ok, psql = pcall(require, "psql")
if not psql_ok then
	print("psql is not installed.")
	return
end

vim.keymap.set("n", "<localleader>r", psql.query_paragraph, map_opts)
vim.keymap.set("n", "<localleader>e", psql.query_current_line, map_opts)
vim.keymap.set("n", "<localleader>y", psql.yank_cell, map_opts)
vim.keymap.set("v", "<localleader>e", psql.query_selection, map_opts)
vim.keymap.set("n", "<C-l>", "20zl")
vim.keymap.set("n", "<C-h>", "40zh")
