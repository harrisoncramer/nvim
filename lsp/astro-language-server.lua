--- @class vim.lsp.Config
return {
	cmd = {
		"astro-ls",
		"--stdio",
	},
	filetypes = {
		"astro",
		"markdown",
		"mdx",
	},
	root_markers = {
		"package.json",
		"tsconfig.json",
		"jsconfig.json",
		"astro.config.mjs",
		".git",
	},
	init_options = {
		typescript = {
			tsdk = "/Users/harrisoncramer/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib",
		},
	},
}
