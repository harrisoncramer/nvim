return {
	setup = function(on_attach, capabilities)
		require("lspconfig").gopls.setup({
			on_attach = function(client, bufnr)
				on_attach(client, bufnr, true)
			end,
			capabilities = capabilities,
		})
	end,
}
