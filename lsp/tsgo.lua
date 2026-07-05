--- @class vim.lsp.Config
return {
	cmd = { "tsgo", "--lsp", "--stdio" },
	cmd_env = {
		GOMEMLIMIT = "3GiB",
		GOGC = "50",
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = {
		"package-lock.json",
		"yarn.lock",
		"pnpm-lock.yaml",
		"bun.lockb",
		"bun.lock",
		".git",
	},
	init_options = {
		hostInfo = "neovim",
		disableAutomaticTypingAcquisition = true,
		preferences = {
			disableSuggestions = false,
			includePackageJsonAutoImports = "off",
		},
	},
}
