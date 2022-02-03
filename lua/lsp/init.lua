local lspconfig_status_ok, lsp_config = pcall(require, "lspconfig")
local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local lsp_installer_status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")

if not (lspconfig_status_ok and cmp_nvim_lsp_status_ok and lsp_installer_status_ok) then
	print("LSPConfig, CMP_LSP, and/or LSPInstaller not installed!")
	return
end

-- Configure CMP
require("lsp.cmp")

-- Map keys after LSP attaches (utility function)
local on_attach = function(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Turn off formatting by default
	client.resolved_capabilities.document_formatting = false

	vim.keymap.set("n", "gd", vim.lsp.buf.definition)
	vim.keymap.set("n", "K", vim.lsp.buf.hover)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
	vim.keymap.set("n", "<leader>[", vim.diagnostic.goto_prev)
	vim.keymap.set("n", "<leader>]", vim.diagnostic.goto_next)
end

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp_installer.on_server_ready(function(server)
	local server_status_ok, server_config = pcall(require, "lsp.servers." .. server.name)
	if not server_status_ok then
		print("The LSP '" .. server.name .. "' does not have a config.")
		server:setup({})
	else
		server_config.setup(on_attach, capabilities, server)
	end
end)

-- Global diagnostic settings
vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	update_in_insert = false,
	float = {
		header = "",
		source = "always",
		border = "rounded",
		focusable = true,
	},
})

-- Change Error Signs in Gutter
local signs = { Error = "✘", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
