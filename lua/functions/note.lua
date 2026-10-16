local file_path = vim.fn.stdpath("config") .. "/notes.md"
local toggle_note_window = require("functions.float").toggle_writeable_window(file_path)

vim.keymap.set("n", "<C-y>", toggle_note_window, merge(global_keymap_opts, { desc = "Toggle notes window" }))

return M
