vim.keymap.set("n", "<leader>m", ":Messages<CR>")

return {
  "AckslD/messages.nvim",
  opts = {
    prepare_buffer = function(opts)
      local buf = vim.api.nvim_create_buf(false, true)
      vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf })
      return vim.api.nvim_open_win(buf, true, opts)
    end,
  }
}
