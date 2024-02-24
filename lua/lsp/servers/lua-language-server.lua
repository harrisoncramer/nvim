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
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = vim.split(package.path, ";"),
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                  "vim",
                  "nnoremap",
                  "vnoremap",
                  "inoremap",
                  "tnoremap",
                  "use",
                },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                checkThirdParty = false,
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
              },
            }
          })
          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
      end,
    })
  end,
}
