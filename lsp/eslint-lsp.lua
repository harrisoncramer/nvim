-- Note: If working with a repository where eslint is specified in the package.json
-- but the node_modules are not installed, install eslint globally: npm i -g eslint
--- @class vim.lsp.Config
return {
	cmd = {
		"vscode-eslint-language-server",
		"--stdio",
	},
	settings = {
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		-- Formatting is handled by Conform
		experimental = {
			useFlatConfig = false,
		},
		nodePath = "",
		onIgnoredFiles = "off",
		problems = {
			shortenToSingleLine = false,
		},
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = false,
		validate = "on",
		workingDirectory = {
			mode = "location",
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = {
		".eslintrc.js",
		".eslintrc.json",
		"eslint.config.js",
		"node_modules",
		".git",
	},
}
