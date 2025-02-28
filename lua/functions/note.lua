local M = {}

local file_path = "~/.config/nvim/notes.md"
M.toggle_note_window = require("functions.float").toggle_writeable_window(file_path)

return M
