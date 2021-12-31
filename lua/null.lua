local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	error("Oh no")
	return
end

local formatting = null_ls.builtins.formatting

-- Configure null-ls for formatting. Using eslintd external dependency.
require("null-ls").setup({
	sources = {
		formatting.eslint_d,
		formatting.prettierd,
		formatting.joker,
		formatting.stylua,
	},
})
-- if client.resolved_capabilities.document_formatting then
--     vim.cmd(
--         "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
-- end
