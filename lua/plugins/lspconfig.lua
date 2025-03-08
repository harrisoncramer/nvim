-- Change Error Signs in Gutter
local signs = { Error = "✘", Warn = " ", Hint = "", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.keymap.set("n", "gw", function()
	local word = vim.fn.expand("<cword>")
	require("plugins.snacks.functions").find_text({ search = word })
end, merge(global_keymap_opts, { desc = "Search word under cursor" }))

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

local global_keymap_opts = { noremap = true, silent = true, nowait = true }
local on_attach = function(child_on_attach)
	return function(client, bufnr)
		if child_on_attach ~= nil then
			child_on_attach(client, bufnr)
		end
		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end

		buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

		-- Debounce by 300ms by default
		-- client.config.flags.debounce_text_changes = 300

		-- This will set up formatting for the attached LSPs
		client.server_capabilities.documentFormattingProvider = true

		-- Turn off semantic tokens (too slow)
		-- if client.server_capabilities.semanticTokensProvider = nil

		-- Keymaps
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, merge(global_keymap_opts, { desc = "Go to definition" }))
		vim.keymap.set(
			"n",
			"gt",
			vim.lsp.buf.type_definition,
			merge(global_keymap_opts, { desc = "Go to type definition" })
		)
		vim.keymap.set(
			"n",
			"gi",
			vim.lsp.buf.implementation,
			merge(global_keymap_opts, { desc = "Go to implementation" })
		)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, merge(global_keymap_opts, { desc = "Go to references" }))

		-- Automatically fill struct (gopls)
		vim.keymap.set("n", "ga", function()
			vim.lsp.buf.code_action({
				filter = function(action)
					return action.kind == "refactor.rewrite.fillStruct"
				end,
				apply = true,
			})
		end, merge(global_keymap_opts, { desc = "Fill struct" }))

		vim.keymap.set("n", "K", vim.lsp.buf.hover, merge(global_keymap_opts, { desc = "Show hover information" }))
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, merge(global_keymap_opts, { desc = "Rename" }))
		vim.keymap.set(
			"n",
			"<leader>lt",
			vim.lsp.buf.type_definition,
			merge(global_keymap_opts, { desc = "Type definition" })
		)
		vim.keymap.set(
			"n",
			"<leader>lc",
			vim.lsp.buf.incoming_calls,
			merge(global_keymap_opts, { desc = "Incoming calls" })
		)

		vim.keymap.set("n", "]W", function()
			vim.diagnostic.jump({
				count = 1,
				severity = vim.diagnostic.severity.ERROR,
				float = true,
			})
		end, merge(global_keymap_opts, { desc = "Next error" }))

		vim.keymap.set("n", "[W", function()
			vim.diagnostic.jump({
				count = 1,
				severity = vim.diagnostic.severity.ERROR,
				float = true,
			})
		end, merge(global_keymap_opts, { desc = "Previous error" }))

		vim.keymap.set("n", "]w", function()
			vim.diagnostic.jump({
				count = 1,
				severity = vim.diagnostic.severity.WARN,
				float = true,
			})
		end, merge(global_keymap_opts, { desc = "Next warning" }))

		vim.keymap.set("n", "[w", function()
			vim.diagnostic.jump({
				count = 1,
				severity = vim.diagnostic.severity.WARN,
				float = true,
			})
		end, merge(global_keymap_opts, { desc = "Previous warning" }))

		vim.keymap.set("n", "<leader>d", function()
			vim.diagnostic.setqflist({})
		end, merge(global_keymap_opts, { desc = "Show diagnostics" }))

		-- This is ripped off from https://github.com/kabouzeid/dotfiles, it's for tailwind preview support
		if client.name == "tailwindcss" then
			require("lsp/colorizer").buf_attach(bufnr, { single_column = false, debounce = 500 })
		end
	end
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
		"davidosomething/format-ts-errors.nvim",
	},
	config = function()
		local servers = require("lsp.init").server_configs
		local lspconfig = require("lspconfig")
		for server, config in pairs(servers) do
			config.on_attach = on_attach(config.on_attach)
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,
}
