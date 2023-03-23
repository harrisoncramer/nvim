vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "conjure-log*",
  callback = function()
    -- Detach all LSP clients from Conjure log files
    -- and disable diagnostics if they're on
    local clients = vim.lsp.get_active_clients()
    for _, c in ipairs(clients) do
      vim.lsp.buf_detach_client(0, c.id)
    end
  end,
  desc = "Turns off LSP for Conjure's buffer",
})

local job = require('plenary.job')

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.clj",
  callback = function()
    local file = vim.fn.expand("%")
    job:new({
      command = 'zprint',
      args = { "-w", file },
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          require("notify")('Could not format file!', "error")
          return
        end
      end,
    }):start()
  end
})

return {
  setup = function(on_attach, capabilities)
    require("lspconfig").clojure_lsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
}
