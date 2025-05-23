--- @class vim.lsp.Config
return {
	cmd = {
		"golangci-lint-langserver",
	},
	filetypes = { "go", "gomod" },
	init_options = {
		command = {
			"/Users/harrisoncramer/.local/share/mise/installs/golangci-lint/v1.64.5/golangci-lint-1.64.5-darwin-arm64/golangci-lint",
			"run",
			"--out-format=json",
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
