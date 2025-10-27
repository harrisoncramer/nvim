--- @class vim.lsp.Config
return {
	cmd = { "prisma-language-server", "--stdio" },
	filetypes = { "prisma" },
	settings = {
		prisma = {
			trace = {
				server = "off",
			},
		},
	},
}
