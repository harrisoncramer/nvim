return {
  setup = function(on_attach, capabilities)
    require("lspconfig").clojure_lsp.setup({
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "*.cljc",
          callback = function()
            -- Detach all LSP clients from Conjure log files
            local clients = vim.lsp.buf_get_clients()
            for _, c in ipairs(clients) do
              vim.lsp.buf_detach_client(0, c.id)
            end
            vim.diagnostic.disable()
          end,
          desc = "Turns off LSP for Conjure's buffer",
        })
        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
    })
  end,
}
