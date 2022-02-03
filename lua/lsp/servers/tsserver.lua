return {
	setup = function(on_attach, capabilities)
		local lspconfig = require("lspconfig")
		lspconfig.tsserver.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
