--- @class vim.lsp.Config
return {
	cmd = {
		"gopls",
	},
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
			staticcheck = false, -- This is configured via the golangci-lint LSP
		},
	},
}
