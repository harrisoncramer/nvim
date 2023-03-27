return {
  setup = function(on_attach, capabilities)
    require("lspconfig").marksman.setup({
      filetypes = { "markdown", "mdx" },
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
