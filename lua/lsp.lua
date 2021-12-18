local remap = _G.remap
local cmp = require'cmp'
local util = require'lspconfig/util'
local lsp_installer = require("nvim-lsp-installer")
local lspkind = require('lspkind')
require('renamer').setup{}

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
    })
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),

  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'ultisnips' },
    { name = 'buffer' },
  })
})

-- Add completion engine to LSP Configuration
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Configure null-ls for formatting. Using eslintd external dependency.
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.eslint_d
    },
})

-- Map keys after LSP attaches (utility function)
local on_attach = function(client, bufnr)

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Turn off formatting by default
  client.resolved_capabilities.document_formatting = false

  remap{ 'n', 'gd', ':lua vim.lsp.buf.definition()<CR>' }
  remap{ 'n', 'gD', ':lua vim.lsp.buf.type_definition()<CR>' }
  remap{ 'n', 'K', ':lua vim.lsp.buf.hover()<CR>' }
  remap{ 'n', 'gi', ':lua vim.lsp.buf.implementation()<CR>' }
  remap{ 'n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>' }
  -- Using renamer plugin.
  remap{'n', 'R', ':lua require("renamer").rename()<cr>'}
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
LspOpts = {
  capabilities = capabilities,
  on_attach = on_attach,
  auto_start = true,
  flags = {
    debounce_text_changes = 150,
  }
}

-- Also installed: tailwindcss, tsserver
-- Loop over installed servers and set them up. Register a handler that will be called for all installed servers.
lsp_installer.on_server_ready(function(server)
    if server.name == "tsserver" then
      -- Having issues with root_dir, just always start it.
      LspOpts.root_dir = util.find_git_ancestor
    end
    if server.name == "clojure_lsp" then
      LspOpts.root_dir = util.root_pattern("project.clj")
    end
    if server.name == "volar" then
       LspOpts.init_options = {
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
       LspOpts.settings = {
         volar = {
            codeLens = {
              references = true,
              pugTools = true,
              scriptSetupTools = true,
            },
         }
       }
      LspOpts.root_dir = util.root_pattern('package.json', 'vue.config.js')
    end
    if server.name == "vuels" then
     LspOpts.root_dir = util.root_pattern("package.json", 'vue.config.js')
     LspOpts.settings = {
         vetur = {
             ignoreProjectWarning = true,
             completion = {
                 autoImport = true,
                 useScaffoldSnippets = true,
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
    LspOpts.settings = {
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
  if server.name == "jsonls" then
    LspOpts.filetypes = { "json", "jsonc" }
  end
  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(LspOpts)
end)
