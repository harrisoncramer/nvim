--- Right now, the Postgres LSP doesn't support SQLC
--- bindings, so we are using a custom SQL validate on save
--- hook for all of our SQL code, and then in dadbod-ui we
--- are using the PostgresLSP. Best of both worlds!

local function should_start_lsp()
	local filename = vim.api.nvim_buf_get_name(0)
	return not filename:match("%.sql$")
end

--- @class vim.lsp.Config
return {
	cmd = {
		"postgres-language-server",
		"lsp-proxy",
	},
	filetypes = {
		"sql",
	},
	root_markers = {
		"postgres-language-server.jsonc",
		"postgrestools.jsonc",
	},
	on_init = function(client, _)
		if not should_start_lsp() then
			client.stop()
		end
	end,
}
