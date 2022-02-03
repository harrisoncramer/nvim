local OS = require("functions").getOS

return {
	setup = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting

		local sources = {
			formatting.stylua,
		}

		if OS() == "Darwin" then
			table.insert(sources, formatting.prettierd)
			table.insert(sources, formatting.joker.with({ filetypes = { "clojure" } }))
		end

		null_ls.setup({
			debug = true,
			on_attach = function(client)
				if client.resolved_capabilities.document_formatting then
					vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
				end
			end,
			sources = sources,
		})
	end,
}
