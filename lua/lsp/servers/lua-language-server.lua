return {
  setup = function(on_attach, capabilities)
    local neodev_ok, neodev = pcall(require, "neodev")
    if not (neodev_ok) then
      vim.api.nvim_err_writeln("Neodev not installed")
    else
      neodev.setup()
    end

    require("lspconfig").lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {
              'vim',
              'require'
            },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            ignoreDir = { "node_modules" }
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      }
    })
  end,
}
