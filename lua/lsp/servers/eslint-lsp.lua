-- Note: If working with a repository where eslint is specified in the package.json
-- but the node_modules are not installed, install eslint globally: npm i -g eslint
local root_pattern = require("lspconfig.util").root_pattern

return {
  config = {
    root_dir = root_pattern(
      ".eslintrc.js",
      "eslint.config.js",
      "node_modules",
      ".git"
    ),
  },
  lsp_name = "eslint"
}
