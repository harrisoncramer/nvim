return {
  setup = function(on_attach, capabilities)
    require("lspconfig").pylsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            -- formatter options
            -- black = { enabled = true },
            -- autopep8 = { enabled = false },
            -- yapf = { enabled = false },
            -- linter options
            pylint = { enabled = true, executable = "pylint" },
            -- pyflakes = { enabled = false },
            -- pycodestyle = { enabled = false },
            -- type checker
            -- pylsp_mypy = { enabled = true },
            -- auto-completion options
            -- jedi_completion = { fuzzy = true },
            -- import sorting
            pyls_isort = { enabled = true },
          },
        },
      }
    })
  end,
}
