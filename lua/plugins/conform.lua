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
				-- These are the configurations for all the formatters
				["eslint_d"] = {
					command = "eslint_d", -- This needs to be in the shell!
					args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
					cwd = require("conform.util").root_file({ "package.json" }),
				},
				prettierd = {
					require_cwd = true,
				},
				["pg_format"] = {
					command = "pg_format",
					args = { "--inplace", "--config", ".pg_format.conf" },
					cwd = require("conform.util").root_file({ ".pg_format" }),
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				typescriptreact = {
					"eslint_d",
					"prettierd",
				},
				typescript = {
					"eslint_d",
					"prettierd",
				},
				json = {
					"prettierd",
				},
				javascript = {
					"eslint_d",
					"prettierd",
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
