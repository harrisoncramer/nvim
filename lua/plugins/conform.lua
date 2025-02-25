vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters = {
				["pg_format"] = {
					command = "pg_format",
					args = { "--inplace" },
					cwd = require("conform.util").root_file({ ".pg_format" }),
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				typescriptreact = {
					"prettierd",
					"prettier",
				},
				typescript = {
					"prettierd",
				},
				javascript = {
					"prettierd",
					stop_after_first = true,
				},
				sql = {
					"pg_format",
				},
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
		})
	end,
}
