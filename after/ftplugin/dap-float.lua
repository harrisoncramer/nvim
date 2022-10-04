local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }

vim.keymap.set("n", "<esc>", ":q<CR>", map_opts)
