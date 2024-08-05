return {
  setup = function(on_attach, capabilities)
    require("lspconfig").yamlls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = {
            ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "api.yaml"
          },
        },
      }
    })
  end,
}
