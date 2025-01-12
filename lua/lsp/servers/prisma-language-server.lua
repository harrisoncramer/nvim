return {
  setup = function(on_attach, capabilities)
    require("lspconfig").prismals.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
}
