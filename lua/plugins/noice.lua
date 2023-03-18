vim.keymap.set("n", "<leader>m", ":messages<CR>")

vim.keymap.set({ "n", "i", "s" }, "<c-d>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { silent = true, expr = true })

vim.keymap.set({ "n", "i", "s" }, "<c-u>", function()
  if not require("noice.lsp").scroll( -4) then
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
    -- Hide "file written" messages and other garbage notifications
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "seconds ago",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "Already at newest change",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "Already at oldest change",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "lines yanked",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "more lines",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          Hind = "",
          find = "fewer lines",
        },
        opts = { skip = true },
      }
    },
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
    -- Show normal command line
    cmdline = {
      view = "cmdline"
    },
  },
}
