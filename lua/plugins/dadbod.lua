return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		local colors = require("colorscheme")

		vim.g.db_async = 2 -- Allow cancelling queries

		vim.cmd(string.format("hi NotificationInfo guifg=%s guibg=%s", colors.sumiInk1, colors.autumnGreen))
		vim.cmd(string.format("hi NotificationWarning guifg=%s guibg=%s", colors.sumiInk1, colors.carpYellow))
		vim.cmd(string.format("hi NotificationError guifg=%s guibg=%s", colors.sumiInk1, colors.autumnRed))
		vim.g.db_ui_save_location = "~/chariot/chariot/db_queries"
		vim.g.db_ui_disable_info_notifications = 1
		vim.g.db_ui_bind_param_pattern = "\\$\\d\\+"

		local personal_config = {
			{
				name = "dev",
				url = function()
					return "postgresql://postgres:postgres@localhost:4444/postgres"
				end,
			},
		}

		local work_config = {
			{
				name = "dev",
				url = function()
					return os.getenv("DEV_DATABASE_URL")
				end,
			},
			{
				name = "staging",
				url = function()
					return os.getenv("STAGING_DATABASE_URL")
				end,
			},
			{
				name = "prod_read_only",
				url = function()
					return os.getenv("PROD_READ_ONLY_DATABASE_URL")
				end,
			},
			{
				name = "sandbox",
				url = function()
					return os.getenv("SANDBOX_DATABASE_URL")
				end,
			},
			{
				name = "prod",
				url = function()
					return os.getenv("PROD_DATABASE_URL")
				end,
			},
			{
				name = "sql-playground",
				url = function()
					return "postgresql://postgres:postgres@localhost:4444/postgres"
				end,
			},
		}

		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.dbs = os.getenv("HOST_NAME") == "harry-work-computer" and work_config or personal_config
	end,
}
