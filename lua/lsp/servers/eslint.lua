return {
	setup = function(on_attach, capabilities, server)
		server:setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
}
