-- Requires external install: npm i -g vscode-langservers-extracted
return {
	setup = function(on_attach, capabilities)
		require("lspconfig").eslint.setup({
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
			end,
			capabilities = capabilities,
		})
	end,
}
