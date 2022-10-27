-- Requires external install: npm i -g vscode-langservers-extracted
local root_pattern = require("lspconfig.util").root_pattern
return {
  setup = function(on_attach, capabilities)
    require("lspconfig").eslint.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = root_pattern(
        ".eslintrc.js",
        "node_modules",
        ".git"
      ),
    })
  end,
}
