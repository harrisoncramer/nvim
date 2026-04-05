vim.keymap.set("n", "<esc>", ":q<CR>", merge(local_keymap_opts, { desc = "Close the window" }))
vim.keymap.set("n", "<C-n>", "<Down>", merge(local_keymap_opts, { desc = "Move down" }))
vim.keymap.set("n", "<C-p>", "<Up>", merge(local_keymap_opts, { desc = "Move up" }))
