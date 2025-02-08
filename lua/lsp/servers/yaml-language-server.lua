return {
	lsp_name = "yamlls",
	config = {
		settings = {
			yaml = {
				schemas = {
					["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "api.yaml",
				},
			},
		},
	},
}
