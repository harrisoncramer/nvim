vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("lsp.servers.gopls").goimports()
  end,
  desc = "Run goimports on save in Golang files",
})

return {
  setup = function(on_attach, capabilities)
    require("lspconfig").gopls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = {
            fillstruct = false
          }
        }
      }
    })
  end,
  goimports = function(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate({ context = { context, "t", true } })
    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then
      return
    end

    for _, val in pairs(result) do
      if val.result == nil then
        goto continue
      end
      local action = val.result[1]
      if action == nil then
        goto continue
      end

      -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
      -- is a CodeAction, it can have either an edit, a command or both. Edits
      -- should be executed first.
      if action.edit or type(action.command) == "table" then
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
        end
        if type(action.command) == "table" then
          vim.lsp.buf.execute_command(action.command)
        end
      else
        vim.lsp.buf.execute_command(action)
      end

      ::continue::
    end

  end,
}
