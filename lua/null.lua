local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- Clojure Formatting w/ Joker
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")
local formatting = null_ls.builtins.formatting
local FORMATTING = methods.internal.FORMATTING

local joker_clj = h.make_builtin({
	method = FORMATTING,
	filetypes = { "clojure" },
	generator_opts = {
		command = "joker",
		args = { "--format", "-" },
		to_stdin = true,
	},
	factory = h.formatter_factory,
})

null_ls.setup({
	debug = true,
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
		end
	end,
	sources = {
		formatting.eslint_d,
		formatting.prettierd,
		formatting.stylua,
		joker_clj,
	},
})
