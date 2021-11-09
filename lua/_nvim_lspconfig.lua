local cmp = require'cmp'
local nvim_lsp = require'lspconfig'

-- Setup completion engine
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) 
    end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'buffer' },
  })
})

-- Add completion engine to LSP Configuration
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Map keys after LSP attaches (utility function)
local on_attach = function(client, bufnr)

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true }

  nnoremap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  nnoremap('gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  nnoremap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  nnoremap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  nnoremap('R', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  nnoremap('<leader>[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  nnoremap('<leader>]', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- nnoremap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- nnoremap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- nnoremap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- nnoremap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- nnoremap('<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- nnoremap('gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- nnoremap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- nnoremap('<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- nnoremap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Hide inline diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

-- Change Error Signs in Gutter
local signs = { Error = "✘", Warn = " ", Hint = "", Info = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


-- Loop over all servers and configure
local servers = { 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
