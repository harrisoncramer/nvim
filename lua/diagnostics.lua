-- Change Error Signs in Gutter
local original_sign_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
	show = function(ns, bufnr, diagnostics, opts)
		if diagnostics then
			local new_diagnostics = {}
			for _, diagnostic in ipairs(diagnostics) do
				if
					diagnostic.message:match("Unexpected statement, found '<<'")
					and diagnostic.severity == vim.diagnostic.severity.WARN
				then
				-- Remove these warnings...
				elseif
					diagnostic.message:match("Unexpected statement, found '<<'")
					and diagnostic.severity == vim.diagnostic.severity.ERROR
				then
					diagnostic.message = "Git conflict detected."
					table.insert(new_diagnostics, diagnostic)
				else
					table.insert(new_diagnostics, diagnostic)
				end
			end
			diagnostics = new_diagnostics
		end
		original_sign_handler.show(ns, bufnr, diagnostics, opts)
	end,
	hide = original_sign_handler.hide,
}

-- Global diagnostic settings
-- vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { link = "NormalFloat" }) -- Keep text of diagnostics white
vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	update_in_insert = false,
	float = {
		source = true,
		header = "",
		border = "solid",
		format = function(diagnostic)
			local severity_symbols = {
				[vim.diagnostic.severity.ERROR] = "✘",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = "",
				[vim.diagnostic.severity.HINT] = "",
			}
			local msg = diagnostic.message
			local sym = severity_symbols[diagnostic.severity] or ""
			return string.format("%s\n%s", sym, msg)
		end,
		focusable = true,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
})
