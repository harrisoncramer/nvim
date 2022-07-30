-- Requires external install: npm i -g vscode-langservers-extracted
return {
	setup = function(on_attach, capabilities)
		require("lspconfig").eslint.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
