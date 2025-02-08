vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "conjure-log*",
	callback = function()
		-- Detach all LSP clients from Conjure log files
		-- and disable diagnostics if they're on
		local clients = vim.lsp.get_active_clients()
		for _, c in ipairs(clients) do
			vim.lsp.buf_detach_client(0, c.id)
		end
	end,
	desc = "Turns off LSP for Conjure's buffer",
})

return {
	lsp_name = "clojure_lsp",
}
