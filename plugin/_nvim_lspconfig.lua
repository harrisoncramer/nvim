local cmp = require'cmp'
local util = require'lspconfig/util'
local lsp_installer = require("nvim-lsp-installer")

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

-- Baseline opts for all Language Servers
local opts = {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
}

-- Loop over installed servers and set them up. Register a handler that will be called for all installed servers.
lsp_installer.on_server_ready(function(server)
    if server.name == "tsserver" then
      opts.root_dir = util.root_pattern("package.json", "webpack.config.js")
    end
    if server.name == "clojure_lsp" then
      opts.root_dir = util.root_pattern("project.clj")
      opts.on_attach = function(client)
          on_attach(client)
      end
    end
    if server.name == "vuels" then
     opts.on_attach = function(client)
         client.resolved_capabilities.document_formatting = true
         on_attach(client)
     end
     opts.capabilities = capabilities
     opts.root_dir = util.root_pattern("package.json", 'vue.config.js')
     opts.settings = {
         vetur = {
             ignoreProjectWarning = true,
             completion = {
                 autoImport = true,
                 useScaffoldSnippets = true,
             },
             format = {
                 defaultFormatter = {
                     html = "prettier",
                     js = "prettier",
                     ts = "prettier",
                 }
             },
             validation = {
                 template = true,
                 script = true,
                 style = true,
                 templateProps = true,
                 interpolation = true
             },
         }
     }
   end
   if server.name == "sumneko_lua" then
    opts.settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim', 'nnoremap',  'inoremap', 'tnoremap', 'use'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            }
        }
    }
  end
  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end)
