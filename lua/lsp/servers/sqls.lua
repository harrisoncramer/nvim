return {
	setup = function(on_attach, capabilities)
		require("lspconfig").sqls.setup({
			settings = {
				sqls = {
					connections = {
						{
							driver = "postgresql",
							dataSourceName = "host=127.0.0.1 port=15432 user=postgres password=postgres dbname=postgres sslmode=disable",
						},
					},
				},
			},
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
