return {
	setup = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		null_ls.setup({
			debug = true,
			on_attach = function(client)
				if client.resolved_capabilities.document_formatting then
					vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
				end
			end,
			sources = {
				formatting.eslint_d,
				-- formatting.prettierd,
				formatting.stylua,
				formatting.joker.with({
					filetypes = {
						"clojure",
					},
				}),
			},
		})
	end,
}
