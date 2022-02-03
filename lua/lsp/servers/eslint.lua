return {
	setup = function(common_on_attach, capabilities, server)
		server:setup({
			on_attach = function(client, bufnr)
				client.resolved_capabilities.document_formatting = true
				common_on_attach(client, bufnr)
			end,
			capabilities = capabilities,
			settings = {
				format = {
					enable = true,
				},
			},
		})
	end,
}
