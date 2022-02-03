return {
	setup = function(common_on_attach, capabilities, server)
		server:setup({
			on_attach = function(client, bufnr)
				common_on_attach(client, bufnr)
				-- Turn formatting on for this server
				client.resolved_capabilities.document_formatting = true
				vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()")
			end,
			capabilities,
			settings = {
				format = {
					enable = true,
				},
			},
		})
	end,
}
