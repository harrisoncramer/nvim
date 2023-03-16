vim.keymap.set("n", "<leader>e", ":IconPickerNormal<cr>")
return {
  "ziontee113/icon-picker.nvim",
  dependencies = { "stevearc/dressing.nvim" },
  opts = {
    disable_legacy_commands = true
  },
}
