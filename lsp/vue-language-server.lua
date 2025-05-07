-- local typescript_path = require("mason-registry").get_package("typescript-language-server"):get_install_path()
-- 	.. "/node_modules/typescript/lib"

--- @class vim.lsp.Config
return {
	filetypes = { "vue" },
	cmd = {
		"vue-language-server",
		"--stdio",
	},
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		scss = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
	init_options = {
		typescript = {
			-- tsdk = typescript_path,
		},
	},
}
