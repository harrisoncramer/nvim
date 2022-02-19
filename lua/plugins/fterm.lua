local fTerm = require("FTerm")
vim.keymap.set("n", "<C-z>", fTerm.toggle, {})
vim.keymap.set("t", "<C-z>", '<C-\\><C-n>:lua require("FTerm").toggle()<CR>')
