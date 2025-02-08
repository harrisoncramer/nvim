vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = {
				"prettierd",
				stop_after_first = true,
			},
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
	},
}
