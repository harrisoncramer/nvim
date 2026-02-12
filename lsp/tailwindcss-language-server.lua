--- @class vim.lsp.Config
return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"css",
		"astro",
		"astro-markdown",
		"html",
		"postcss",
		"sass",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	init_options = {
		userLanguages = {
			eelixir = "html-eex",
			eruby = "erb",
		},
	},
	on_new_config = function(new_config)
		if not new_config.settings then
			new_config.settings = {}
		end
		if not new_config.settings.editor then
			new_config.settings.editor = {}
		end
		if not new_config.settings.editor.tabSize then
			new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
		end
	end,
	capabilities = {
		textDocument = {
			colorProvider = false,
		},
	},
	root_markers = {
		"tailwind.config.js",
		"tailwind.config.ts",
		"postcss.config.js",
		"postcss.config.ts",
		"package.json",
		"node_modules",
		".git",
	},
	settings = {
		tailwindCSS = {
			classAttributes = { "class", "className", "classList", "ngClass" },
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidConfigPath = "error",
				invalidScreen = "error",
				invalidTailwindDirective = "error",
				invalidVariant = "error",
				recommendedVariantOrder = "warning",
			},
			validate = true,
		},
	},
}
