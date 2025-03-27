--- @class vim.lsp.Config
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust", "rs" },
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
			diagnostics = {
				enable = true,
			},
		},
	},
}
