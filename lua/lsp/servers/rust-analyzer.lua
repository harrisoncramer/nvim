return {
  config = {
    filetypes = { "rust", "rs" },
    settings = {
      ['rust-analyzer'] = {
        check = {
          command = "clippy",
        },
        diagnostics = {
          enable = true,
        }
      }
    }
  },
  lsp_name = "rust_analyzer",
}
