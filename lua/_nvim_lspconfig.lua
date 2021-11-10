local cmp = require'cmp'
local nvim_lsp = require'lspconfig'
local util = require 'lspconfig/util'


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


-- Loop over all servers and configure those that don't require any other complex additional functionality
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

-- VUEJS --
nvim_lsp.vuels.setup {
  on_attach = function(client)
      --[[
          Internal Vetur formatting is not supported out of the box

          This line below is required if you:
              - want to format using Nvim's native `vim.lsp.buf.formatting**()`
              - want to use Vetur's formatting config instead, e.g, settings.vetur.format {...}
      --]]
      client.resolved_capabilities.document_formatting = true
      on_attach(client)
  end,
  capabilities = capabilities,
  settings = {
      vetur = {
          ignoreProjectWarning = true,
          completion = {
              autoImport = true,
              useScaffoldSnippets = true,
          },
          format = {
              defaultFormatter = {
                  html = "none",
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
          experimental = {
              templateInterpolationService = true
          }
      }
  },
  root_dir = util.root_pattern("header.php", "package.json", "style.css", 'webpack.config.js')
}


-- LUA --
-- Install language server in ~/.config/nvim via: https://github.com/sumneko/lua-language-server/wiki/Build-and-Run
USER = vim.fn.expand('$USER')

local sumneko_root_path = ""
local sumneko_binary = ""

if vim.fn.has("mac") == 1 then
    sumneko_root_path = "/Users/" .. USER .. "/.config/nvim/lua-language-server"
    sumneko_binary = "/Users/" .. USER .. "/.config/nvim/lua-language-server/bin/macOS/lua-language-server"
elseif vim.fn.has("unix") == 1 then
    sumneko_root_path = "/home/" .. USER .. "/.config/nvim/lua-language-server"
    sumneko_binary = "/home/" .. USER .. "/.config/nvim/lua-language-server/bin/Linux/lua-language-server"
else
    print("Unsupported system for sumneko")
end

require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim', 'nnoremap'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            }
        }
    }
}
