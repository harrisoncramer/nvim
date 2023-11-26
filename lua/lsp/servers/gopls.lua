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
  goimports = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end,
}
