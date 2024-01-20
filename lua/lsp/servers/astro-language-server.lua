local root_pattern = require("lspconfig.util").root_pattern
return {
  setup = function(on_attach, capabilities)
    require("lspconfig").astro.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = root_pattern(
        "package.json",
        "tsconfig.json",
        "jsonconfig.json",
        ".git"
      ),
    })
  end,
}
