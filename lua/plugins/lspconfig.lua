local u = require("functions.utils")

-- Change Error Signs in Gutter
local signs = { Error = "✘", Warn = " ", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local original_publish_handler = vim.diagnostic.handlers.signs
vim.diagnostic.handlers.signs = {
  show = function(ns, bufnr, diagnostics, opts)
    if diagnostics then
      local new_diagnostics = {}
      for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.message:match("Unexpected statement, found '<<'") and diagnostic.severity == vim.diagnostic.severity.WARN then
          -- Remove these warnings...
        elseif diagnostic.message:match("Unexpected") and diagnostic.severity == vim.diagnostic.severity.ERROR then
          diagnostic.message = "Git conflict detected."
          table.insert(new_diagnostics, diagnostic)
        else
          table.insert(new_diagnostics, diagnostic)
        end
      end
      diagnostics = new_diagnostics
    end
    original_publish_handler.show(ns, bufnr, diagnostics, opts)
  end,
}

local map_opts = { noremap = true, silent = true, nowait = true }
local on_attach = function(client, bufnr)
  local lsp_format = require("lsp-format")
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
        "rust_analyzer",
        "prismals"
      }, client.name)) then
    lsp_format.on_attach(client)
  end

  -- Keymaps
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, map_opts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, map_opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, map_opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, map_opts)

  -- Automatically fill struct (gopls)
  vim.keymap.set("n", "ga", function()
    vim.lsp.buf.code_action({
      filter = function(action)
        return action.kind == "refactor.rewrite.fillStruct"
      end,
      apply = true
    })
  end, map_opts)

  vim.keymap.set("n", "K", vim.lsp.buf.hover, map_opts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, map_opts)
  vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, map_opts)
  vim.keymap.set("n", "<leader>lc", vim.lsp.buf.incoming_calls, map_opts)

  vim.keymap.set("n", "]W", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
  end)

  vim.keymap.set("n", "[W", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
  end)

  vim.keymap.set("n", "]w", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
  end)

  vim.keymap.set("n", "[w", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
  end)


  vim.keymap.set("n", "<leader>d", function()
    vim.diagnostic.setqflist({})
  end)

  -- This is ripped off from https://github.com/kabouzeid/dotfiles, it's for tailwind preview support
  if client.name == "tailwindcss" then
    require("lsp/colorizer").buf_attach(bufnr, { single_column = false, debounce = 500 })
  end
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp',
    'lukas-reineke/lsp-format.nvim',
    'davidosomething/format-ts-errors.nvim',
  },
  config = function()
    local servers = require("lsp.init").server_configs
    local lspconfig = require('lspconfig')
    for server, config in pairs(servers) do
      config.on_attach = on_attach
      config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      lspconfig[server].setup(config)
    end
    local lsp_format = require("lsp-format")
    lsp_format.setup({
      order = {
        "ts_ls",
        "eslint",
      }
    })
  end
}
