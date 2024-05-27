return {
  setup = function(on_attach, capabilities)
    require("lspconfig").clangd.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
