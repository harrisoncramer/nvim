local M = {}

local file_path = "~/.config/nvim/notes.md"
M.toggle_note_window = require("lua.functions.float").toggle_floating_window(file_path)

return M
