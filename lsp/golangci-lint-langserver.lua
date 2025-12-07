local isChariot = vim.fn.getcwd() == "/Users/harrisoncramer/chariot/chariot"

--- @class vim.lsp.Config
return {
	cmd = {
		"golangci-lint-langserver",
	},
	filetypes = { "go", "gomod" },
	init_options = {
		command = {
			isChariot and "custom-gcl" or "golangci-lint",
			"run",
			"--output.json.path",
			"stdout",
			"--show-stats=false",
		},
	},
	root_markers = {
		".golangci.yml",
		".golangci.yaml",
		".golangci.toml",
		".golangci.json",
		"go.work",
		"go.mod",
		".git",
	},
}
