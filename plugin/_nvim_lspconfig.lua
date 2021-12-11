local remap = _G.remap
local cmp = require'cmp'
local util = require'lspconfig/util'
local lsp_installer = require("nvim-lsp-installer")
local lspkind = require('lspkind')

-- Setup completion engine
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = false, -- do not show text alongside icons
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        return vim_item
      end
    })
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

  -- Turn off formatting by default
  client.resolved_capabilities.document_formatting = false

  -- local opts = { noremap=true, silent=true }

  remap{ 'n', 'gd', ':lua vim.lsp.buf.definition()<CR>' }
  remap{ 'n', 'gD', ':lua vim.lsp.buf.type_definition()<CR>' }
  remap{ 'n', 'K', ':lua vim.lsp.buf.hover()<CR>' }
  remap{ 'n', 'gi', ':lua vim.lsp.buf.implementation()<CR>' }
  remap{ 'n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>' }
  remap{ 'n', 'R', ':lua vim.lsp.buf.rename()<CR>' }
  remap{ 'n', '<leader>[', ':lua vim.lsp.diagnostic.goto_prev()<CR>' }
  remap{ 'n', '<leader>]', ':lua vim.lsp.diagnostic.goto_next()<CR>' }
end

-- Hide inline diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        severity_sort = true
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

-- Also installed: tailwindcss, tsserver
-- Loop over installed servers and set them up. Register a handler that will be called for all installed servers.
lsp_installer.on_server_ready(function(server)
    if server.name == "clojure_lsp" then
      opts.root_dir = util.root_pattern("project.clj")
    end
    if server.name == "volar" then
       opts.init_options = {
          typescript = {
              serverPath = vim.api.nvim_eval('$TS_SERVER'), -- This must be passed in via the startup in .zshrc....
          },
          languageFeatures = {
            references = true,
            definition = true,
            typeDefinition = true,
            callHierarchy = true,
            hover = true,
            rename = true,
            signatureHelp = true,
            codeAction = true,
            completion = {
                defaultTagNameCase = 'both',
                defaultAttrNameCase = 'kebabCase',
            },
            schemaRequestService = true,
            documentHighlight = true,
            codeLens = true,
            semanticTokens = true,
            diagnostics = true,
          },
          documentFeatures = {
            selectionRange = true,
            foldingRange = true,
            linkedEditingRange = true,
            documentSymbol = true,
            documentColor = true,
         }
       }
       opts.settings = {
         volar = {
            codeLens = {
              references = true,
              pugTools = true,
              scriptSetupTools = true,
            },
         }
       }
      opts.root_dir = util.root_pattern('package.json', 'vue.config.js')
    end
    if server.name == "eslint" then
     opts.on_attach = function(client)
       client.resolved_capabilities.document_formatting = true
       on_attach(client)
     end
     opts.root_dir = util.root_pattern('.eslintrc.js', '.eslintignore')
    end
    if server.name == "vuels" then
     opts.root_dir = util.root_pattern("package.json", 'vue.config.js')
     opts.settings = {
         vetur = {
             ignoreProjectWarning = true,
             completion = {
                 autoImport = true,
                 useScaffoldSnippets = true,
             },
             -- Formatting is off by default
             -- format = {
             --     defaultFormatter = {
             --         html = "prettier",
             --         js = "prettier",
             --         ts = "prettier",
             --     }
             -- },
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
                globals = {'vim', 'nnoremap',  'vnoremap', 'inoremap', 'tnoremap', 'use'}
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
