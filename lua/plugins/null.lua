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

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local format = function(payload)
	vim.lsp.buf.format({
		filter = function(clients)
			return vim.tbl_filter(function(client)
				return client.name ~= "volar"
			end, clients)
		end,
	})
end

null_ls.setup({
	debug = false,
	sources = sources,
	on_attach = function(client, bufnr)
		if client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				-- on 0.8, you should use vim.lsp.buf.format instead
				callback = format,
			})
		end
	end,
})
