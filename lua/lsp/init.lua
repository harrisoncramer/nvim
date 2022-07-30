local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local mason_status_ok, mason = pcall(require, "mason")
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")

if not (mason_status_ok and mason_lspconfig_ok and cmp_nvim_lsp_status_ok) then
	print("Mason, Mason LSP Config, or Completion not installed!")
	return
end

-- Map keys after LSP attaches (utility function)
local on_attach = function(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Debounce by 300ms by default
	client.config.flags.debounce_text_changes = 300
	client.server_capabilities.documentFormattingProvider = false

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
	vim.keymap.set("n", "<leader>]", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end)
	vim.keymap.set("n", "<leader>[", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end)

	vim.keymap.set("n", "<leader>w", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARNING })
	end)

	-- This is ripped off from https://github.com/kabouzeid/dotfiles, it's for tailwind preview support
	if client.server_capabilities.colorProvider then
		require("lsp/colorizer").buf_attach(bufnr, { single_column = false, debounce = 500 })
	end
end

local normal_capabilities = vim.lsp.protocol.make_client_capabilities()

-- From nvim-ufo
normal_capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

local capabilities = cmp_nvim_lsp.update_capabilities(normal_capabilities)

-- These servers are automatically installed by Mason.
-- We then iterate over their names and load their relevant
-- configuration files, which are stored in lua/lsp/servers,
-- passing along the global on_attach and capabilities functions
local servers = {
	"lua-language-server",
	"typescript-language-server",
	"tailwindcss-language-server",
	"clojure-lsp",
	"vue-language-server",
	"vscode-eslint-language-server",
}

-- Setup Mason + LSPs + CMP
require("lsp.cmp")
mason_lspconfig.setup({ ensure_installed = servers, automatic_installation = true })
mason.setup({})

-- Setup each server
for _, s in pairs(servers) do
	local server_config_ok, mod = pcall(require, "lsp.servers." .. s)
	if not server_config_ok then
		print("The LSP '" .. s .. "' does not have a config.")
	else
		mod.setup(on_attach, capabilities)
	end
end

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
