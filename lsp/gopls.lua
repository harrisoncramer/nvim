--- @class vim.lsp.Config
return {
	cmd = { "gopls" },
	filetypes = { "go" },
	settings = {
		gopls = {
			semanticTokens = true,
			usePlaceholders = true,
			completeFunctionCalls = true,
			analyses = {
				fillstruct = false,
				unusedparams = true,
			},
			staticcheck = true, -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md#staticcheck-bool
		},
	},
}
