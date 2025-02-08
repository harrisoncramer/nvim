local root_pattern = require("lspconfig.util").root_pattern

return {
	config = {
		root_dir = root_pattern("package.json", "tsconfig.json", "jsonconfig.json", ".git"),
	},
	lsp_name = "astro",
}
