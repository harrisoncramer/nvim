--- @class vim.lsp.Config
return {
	cmd = {
		"yaml-language-server",
		"--stdio",
	},
	filetypes = {
		"yaml",
		"yaml.docker-compose",
		"yaml.gitlab",
	},
	settings = {
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "api.yaml",
				["https://json.schemastore.org/sqlc-2.0.json"] = "sqlc.yaml",
			},
		},
	},
}
