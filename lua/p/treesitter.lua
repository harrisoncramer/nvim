require('nvim-treesitter.configs').setup({
  ignore_install = { "haskell" },
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true
  }
})
