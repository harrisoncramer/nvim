local List = require("functions.list")
local u = require("functions.utils")
local mason_status_ok, mason = pcall(require, "mason")
local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")

if not (mason_status_ok and mason_tool_installer_ok) then
  vim.api.nvim_err_writeln("Mason, Mason Tool Installer, Completion, or LSP Format not installed!")
  return
end

local M = {}

mason.setup()

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
  "typescript-language-server",
  "tailwindcss-language-server",
  "vue-language-server",
  "python-lsp-server",
  "terraform-ls",
  "css-lsp",
  "clangd",
  "yaml-language-server",
  "prisma-language-server",
  "protols"
}

local linters = {
  "pylint"
}

local debuggers = {
  "js-debug-adapter",
  "delve",
  -- "node-debug2-adapter", TODO: Not working
}

local all = u.merge(servers, linters, debuggers)

mason_tool_installer.setup({
  ensure_installed = all,
  run_on_start = true,
  automatic_installation = true
})

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

-- This is the callback function that runs after LSP attaches which configures the LSP,
-- which sets the LSP settings like formatting and keymaps, etc.
local s = List.new(servers)
M.server_configs = s:reduce(function(acc, value)
  local serverConfig = require("lsp.servers." .. value)

  -- If we don't provide a config, use an empty table
  if serverConfig.config == nil then
    serverConfig.config = {}
  end

  -- If we don't provide a server name, it means the file name
  -- and the server name actually match
  if serverConfig.lsp_name == nil then
    serverConfig.lsp_name = value
  end

  acc[serverConfig.lsp_name] = serverConfig.config
  return acc
end, {})



return M
