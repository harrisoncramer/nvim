return {
  'ThePrimeagen/harpoon',
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.keymap.set("n", "<leader>ha", require("harpoon.mark").add_file)
    vim.keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu)
  end
}
