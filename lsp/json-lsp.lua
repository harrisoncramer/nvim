--- @class vim.lsp.Config
return {
	cmd = {
		"vscode-json-language-server",
		"--stdio",
	},
	filetypes = {
		"json",
		"jsonc",
	},
	{
		provideFormatter = false,
	},
}
