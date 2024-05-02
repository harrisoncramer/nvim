local vue_typescript_plugin = require('mason-registry')
    .get_package('vue-language-server')
    :get_install_path()
    .. '/node_modules/@vue/language-server'
    .. '/node_modules/@vue/typescript-plugin'

return {
  setup = function(on_attach, capabilities)
    local lspconfig = require("lspconfig")
    lspconfig.tsserver.setup({
      init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_typescript_plugin,
            languages = { "javascript", "typescript", "vue" },
          },
        },
      },
      filetypes = {
        "javascript",
        "typescript",
        "vue",
      },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig.volar.setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
