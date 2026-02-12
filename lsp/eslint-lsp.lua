-- Note: If working with a repository where eslint is specified in the package.json
-- but the node_modules are not installed, install eslint globally: npm i -g eslint
--- @class vim.lsp.Config
return {
	cmd = {
		"vscode-eslint-language-server",
		"--stdio",
	},
	settings = {
		validate = "on",
		packageManager = nil,
		useESLintClass = false,
		experimental = {
			useFlatConfig = false,
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = false,
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onType",
		problems = {
			shortenToSingleLine = false,
		},
		nodePath = "",
		workingDirectory = {
			mode = "location",
		},
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
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
