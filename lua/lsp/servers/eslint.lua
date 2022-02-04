return {
	setup = function(common_on_attach, capabilities, server)
		server:setup({
			on_attach = function(client, bufnr)
				common_on_attach(client, bufnr)
				-- Turn formatting on for this server
				client.resolved_capabilities.document_formatting = true
			end,
			capabilities,
		})
	end,
}
