local vue_typescript_plugin = require('mason-registry').get_package('vue-language-server'):get_install_path()
    .. '/node_modules/@vue/language-server'
    .. '/node_modules/@vue/typescript-plugin'

return {
  setup = function(on_attach, capabilities)
    local ok, format_ts_errors = pcall(require, "format-ts-errors")
    if not ok then
      vim.api.nvim_err_writeln("Formatting for TS Errors not installed!")
      return
    end
    local lspconfig = require("lspconfig")
    lspconfig.ts_ls.setup({
      handlers = {
        ["textDocument/publishDiagnostics"] = function(
            _,
            result,
            ctx,
            config
        )
          if result.diagnostics == nil then
            return
          end

          local idx = 1
          while idx <= #result.diagnostics do
            local entry = result.diagnostics[idx]
            local formatter = format_ts_errors[entry.code]
            entry.message = formatter and formatter(entry.message) or entry.message
            -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
            if entry.code == 80001 then
              -- ESM Vs. CommonJS
              table.remove(result.diagnostics, idx)
            else
              idx = idx + 1
            end
          end

          vim.lsp.diagnostic.on_publish_diagnostics(
            _,
            result,
            ctx,
            config
          )
        end,
      },
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_typescript_plugin,
            languages = { "javascript", "typescript", "vue", "javascriptreact", "typescriptreact", "vue" },
          },
        },
      },
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
      },
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
      end
    })

    lspconfig.volar.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    })
  end,
}
