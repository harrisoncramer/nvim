return {
  setup = function(on_attach, capabilities)
    local lspconfig = require("lspconfig")
    lspconfig.cssls.setup({
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
  end
}
