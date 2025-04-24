--- @class vim.lsp.Config
return {
	cmd = {
		"golangci-lint-langserver",
	},
	filetypes = { "go", "gomod" },
	init_options = {
		command = {
			"/Users/harrisoncramer/.dotfiles/scripts/bin/golangci-lint__old",
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

-- return {
-- 	cmd = {
-- 		"golangci-lint-langserver",
-- 	},
-- 	filetypes = { "go", "gomod" },
-- 	init_options = {
-- 		command = {
-- 			"golangci-lint",
-- 			"run",
-- 			"--output.json.path",
-- 			"stdout",
-- 			"--show-stats=false",
-- 			"--issues-exit-code=1",
-- 			-- Chariot hasn't migrated to v3 yet, so pass a config path option
-- 			"-c",
-- 			"~/.golangci.chariot.v3.yml",
-- 		},
-- 	},
-- 	root_markers = {
-- 		".golangci.yml",
-- 		".golangci.yaml",
-- 		".golangci.toml",
-- 		".golangci.json",
-- 		"go.work",
-- 		"go.mod",
-- 		".git",
-- 	},
-- }
