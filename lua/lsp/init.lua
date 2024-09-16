local map_opts = { noremap = true, silent = true, nowait = true }
local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local mason_status_ok, mason = pcall(require, "mason")
local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
local lsp_format_ok, lsp_format = pcall(require, "lsp-format")
local u = require("functions.utils")

if not (mason_status_ok and mason_tool_installer_ok and cmp_nvim_lsp_status_ok and lsp_format_ok) then
  vim.api.nvim_err_writeln("Mason, Mason Tool Installer, Completion, or LSP Format not installed!")
  return
end

mason.setup()

lsp_format.setup({
  order = {
    "ts_ls",
    "eslint",
  }
})

-- This is the callback function that runs after LSP attaches which configures the LSP,
-- which sets the LSP settings like formatting and keymaps, etc.
local on_attach = function(client, bufnr)
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

  -- Formatting for Vue handled by Eslint
  -- Formatting for Clojure handled by custom ZPrint function, see lua/lsp/servers/clojure-lsp.lua
  if (u.has_value({
        "eslint",
        "gopls",
        "astro",
        "terraformls",
        "lua_ls",
        "pylsp",
        "clangd",
        "rust_analyzer"
      }, client.name)) then
    lsp_format.on_attach(client)
  end

  -- Keymaps
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, map_opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, map_opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)
  vim.keymap.set("n", "gss", function()
    vim.cmd.vsplit()
    vim.lsp.buf.definition()
  end, map_opts)
  vim.keymap.set("n", "gsv", function()
    vim.cmd.split()
    vim.lsp.buf.definition()
  end, map_opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, map_opts)
  vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, map_opts)
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, map_opts)
  vim.keymap.set("n", "<leader>lc", vim.lsp.buf.incoming_calls, map_opts)

  vim.keymap.set("n", "]W", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end)

  vim.keymap.set("n", "[W", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end)

  vim.keymap.set("n", "]w", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
  end)

  vim.keymap.set("n", "[w", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
  end)


  vim.keymap.set("n", "<leader>d", function()
    vim.diagnostic.setqflist({})
  end)

  -- This is ripped off from https://github.com/kabouzeid/dotfiles, it's for tailwind preview support
  if client.name == "tailwindcss" then
    require("lsp/colorizer").buf_attach(bufnr, { single_column = false, debounce = 500 })
  end
end

-- These tools are automatically installed by Mason.
-- We then iterate over the LSPs (only) and load their relevant
-- configuration files, which are stored in lua/lsp/servers,
-- passing along the global on_attach and capabilities functions

-- We could have configurations for the other tools but it's not
-- been necessary for me thus far
local servers = {
  "rust-analyzer",
  "lua-language-server",
  "clojure-lsp",
  "eslint-lsp",
  "bash-language-server",
  "gopls",
  "golangci-lint-langserver",
  "astro-language-server",
  "marksman",
  "typescript-language-server",
  "tailwindcss-language-server",
  "vue-language-server",
  "python-lsp-server",
  "terraform-ls",
  "css-lsp",
  "clangd",
  "yaml-language-server"
}

local linters = {
  "pylint"
}

local debuggers = {
  "js-debug-adapter",
  "delve",
  "node-debug2-adapter",
}

local all = u.merge(servers, linters, debuggers)

-- Setup Mason + LSPs + CMP
require("lsp.cmp")
mason_tool_installer.setup({
  ensure_installed = all,
  run_on_start = true,
  automatic_installation = true
})

-- Setup each server
local normal_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = cmp_nvim_lsp.default_capabilities(normal_capabilities)
for _, s in pairs(servers) do
  local server_config_ok, mod = pcall(require, "lsp.servers." .. s)
  if not server_config_ok then
    require("notify")("The LSP '" .. s .. "' does not have a config.", "warn")
  else
    mod.setup(on_attach, capabilities)
  end
end

-- Global diagnostic settings
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  update_in_insert = false,
  float = {
    header = "",
    source = true,
    border = "solid",
    focusable = true,
  },
})

-- Change Error Signs in Gutter
local signs = { Error = "✘", Warn = " ", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "solid",
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "solid",
  })
