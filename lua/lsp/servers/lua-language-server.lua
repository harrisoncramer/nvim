return {
	setup = function(on_attach, capabilities)
		require("lspconfig").sumneko_lua.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
						-- Setup your lua path
						path = vim.split(package.path, ";"),
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = {
							"vim",
							"nnoremap",
							"vnoremap",
							"inoremap",
							"tnoremap",
							"use",
						},
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						},
					},
				},
			},
		})
	end,
}
