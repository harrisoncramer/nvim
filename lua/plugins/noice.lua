vim.keymap.set("n", "<leader>m", ":messages<CR>")

vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-b>"
  end
end, { silent = true, expr = true })

return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    format = {
      conceal = true,
    },
    lsp = {
      -- signature = {
      --   enabled = false
      -- },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    messages = {
      enabled = false
    },
    -- Show normal command line
    cmdline = {
      view = "cmdline",
      format = {
        cmdline = { icon = ">" },
        search_up = { icon = "?" },
        search_down = { icon = "/" },
        lua = { icon = "lua" },
        help = { icon = "help:" },
      }
    },
  },
}
