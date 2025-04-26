--- @class vim.lsp.Config
return {
	cmd = {
		"postgrestools",
		"lsp-proxy",
	},
	filetypes = {
		"sql",
	},
	root_markers = {
		"postgrestools.jsonc",
	},
}
