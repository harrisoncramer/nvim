return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = "zbirenbaum/copilot-cmp",
  cond = function()
    return vim.env.COMPUTER == "personal"
  end,
  config = function()
    require("copilot").setup({
      panel = {
        enabled = false
      },
      suggestion = {
        auto_trigger = false,
      }
    })
    require("copilot_cmp").setup({
      formatters = {
        insert_text = require("copilot_cmp.format").remove_existing
      },
    })
  end
}
