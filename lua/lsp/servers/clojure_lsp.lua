return {
	setup = function(common_on_attach, capabilities, server)
		server:setup({
			on_attach = common_on_attach,
			capabilities,
		})
	end,
}
