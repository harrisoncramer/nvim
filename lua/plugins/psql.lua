-- Password is hard-coded in the plugin for now to "postgres"
local psql = require("psql")
psql.setup({
	host = "localhost",
	database_name = "postgres",
	username = "postgres",
	port = 5432,
})

local map_opts = { noremap = true, silent = true, nowait = true }
vim.keymap.set("n", "<leader>r", psql.query_paragraph, map_opts)
vim.keymap.set("n", "<leader>e", psql.query_current_line, map_opts)
