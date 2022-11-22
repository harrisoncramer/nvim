require("leap").add_default_mappings()

-- Unbind these keymappings for visual mode
vim.keymap.del("x", "X")
vim.keymap.del("v", "x")
