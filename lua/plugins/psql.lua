-- Password is hard-coded in the plugin for now to "postgres"
require("psql").setup({
	host = "localhost",
	database_name = "postgres",
	username = "postgres",
	port = 5432,
})
