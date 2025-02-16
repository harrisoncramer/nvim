local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }

vim.keymap.set("n", "<C-k>", "<Plug>(DBUI_JumpToForeignKey)", map_opts)
