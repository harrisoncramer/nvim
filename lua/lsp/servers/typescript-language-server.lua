local vue_typescript_plugin = require("mason-registry").get_package("vue-language-server"):get_install_path()
	.. "/node_modules/@vue/language-server"
	.. "/node_modules/@vue/typescript-plugin"

return {
	lsp_name = "ts_ls",
	config = {
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
		init_options = {
			plugins = {
				{
					name = "@vue/typescript-plugin",
					location = vue_typescript_plugin,
					languages = { "javascript", "typescript", "vue", "javascriptreact", "typescriptreact", "vue" },
				},
			},
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
		on_attach = function(_, bufnr)
			-- Automatically add missing imports before saving
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.code_action({
						context = {
							only = { "source.addMissingImports.ts" },
						},
						apply = true,
					})
				end,
			})
		end,
	},
}
