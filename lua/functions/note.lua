local file_path = "~/.config/nvim/notes.md"
local toggle_note_window = require("functions.float").toggle_writeable_window(file_path)

vim.keymap.set("n", "<C-y>", toggle_note_window, merge(global_keymap_opts, { desc = "Toggle notes window" }))

return M
