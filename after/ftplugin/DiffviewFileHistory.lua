local u = require("functions.utils")
vim.keymap.set("n", "e", function()
  local diffview = require("diffview")
  local content = u.get_line_content()
  local words = u.make_words_from_string(content)
  local commit = words[4]
  vim.cmd(":Gtabedit " .. commit .. ":" .. diffview.FOCUSED_HISTORY_FILE)
  P(commit)
end)
