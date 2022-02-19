vim.keymap.set("x", "iu", ':lua require"treesitter-unit".select()<CR>')
vim.keymap.set("x", "au", ':lua require"treesitter-unit".select(true)<CR>')
vim.keymap.set("o", "iu", ':<c-u>lua require"treesitter-unit".select()<CR>')
vim.keymap.set("o", "au", ':<c-u>lua require"treesitter-unit".select(true)<CR>')
