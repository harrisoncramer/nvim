return {
  setup = function(on_attach, capabilities)
    require("lspconfig").rust_analyzer.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "rust", "rs" },
      settings = {
        ['rust-analyzer'] = {
          check = {
            command = "clippy",
          },
          diagnostics = {
            enable = true,
          }
        }
      }
    })
  end,
}
