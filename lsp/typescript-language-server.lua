local function add_autoimport_cmd()
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = vim.api.nvim_create_augroup("ts_fix_imports", { clear = true }),
		desc = "Add missing imports and remove unused imports for TS",
		pattern = { "*.ts", "*.tsx" },
		callback = function()
			local clients = vim.lsp.get_active_clients({ bufnr = 0 })
			for _, client in ipairs(clients) do
				if client.name == "ts_ls" then
					local params = vim.lsp.util.make_range_params(nil, "utf-8")
					params.context = {
						only = {
							"source.addMissingImports.ts",
							"source.removeUnused.ts",
						},
					}
					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
					for _, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.kind == "source.addMissingImports.ts" or r.kind == "source.removeUnused.ts" then
								vim.lsp.buf.code_action({
									apply = true,
									context = { only = { r.kind } },
								})
								vim.cmd("write")
							end
						end
					end
					break
				end
			end
		end,
	})
end

--- @class vim.lsp.Config
return {
	name = "typescript-language-server",
	cmd = { "typescript-language-server", "--stdio" },
	handlers = {
		["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
			local format_ts_errors = require("format-ts-errors")
			if result.diagnostics == nil then
				return
			end

			local idx = 1
			while idx <= #result.diagnostics do
				local entry = result.diagnostics[idx]
				local formatter = format_ts_errors[entry.code]
				entry.message = formatter and formatter(entry.message) or entry.message
				-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
				if entry.code == 80001 then
					-- ESM Vs. CommonJS
					table.remove(result.diagnostics, idx)
				else
					idx = idx + 1
				end
			end

			vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
		end,
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	on_attach = function(client, bufnr)
		add_autoimport_cmd()
		require("lsp").on_attach(client, bufnr)
	end,
}
