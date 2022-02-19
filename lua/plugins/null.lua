local u = require("functions.utils")

local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting

local sources = {
	formatting.eslint_d,
	formatting.stylua,
}

if u.get_os() == "Darwin" then
	table.insert(sources, formatting.prettierd)
	table.insert(sources, formatting.joker.with({ filetypes = { "clojure" } }))
end

null_ls.setup({
	debug = false,
	sources = sources,
	on_attach = function(client)
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()")
		client.resolved_capabilities.document_formatting = true
	end,
})
