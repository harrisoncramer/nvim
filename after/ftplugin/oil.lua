vim.keymap.set("n", "<Esc>", "<cmd>q<cr>", { buffer = true }, merge(local_keymap_opts, { desc = "Close window" }))
