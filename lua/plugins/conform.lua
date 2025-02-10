vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

return {
	"stevearc/conform.nvim",
	opts = {
		formatters = {
			["sql-formatter"] = {
				command = "sql-formatter",
				args = { "-l", "postgresql" },
			},
		},
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = {
				"prettierd",
			},
			javascript = {
				"prettierd",
				stop_after_first = true,
			},
			sql = {
				"sql-formatter",
			},
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
	},
}
