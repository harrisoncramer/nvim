return {
  "ton/vim-bufsurf",
  config = function()
    vim.keymap.set("n", "<C-n>", ":BufSurfForward<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<C-p>", ":BufSurfBack<CR>", { silent = true, noremap = true })
  end
}
