return {
  'rlane/pounce.nvim',
  config = function()
    vim.keymap.set("n", "m", ":Pounce<CR>")
  end
}
