--- @class vim.lsp.Config
return {
	cmd = {
		"clangd",
	},
	root_markers = {
		".clangd",
		"compile_commands.json",
	},
	filetypes = {
		"c",
		"cpp",
	},
}
