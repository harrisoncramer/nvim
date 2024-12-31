local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }
local u = require("functions.utils")

-- See diff of changes in this specific commit
vim.keymap.set("n", "d", function()
  local sha = u.get_word_under_cursor()
  vim.print(sha)
  vim.api.nvim_feedkeys(string.format(":DiffviewOpen %s~1..%s", sha, sha), "n", false)
  u.press_enter()
end, map_opts)

-- See diff of all changes against origin in this commit
vim.keymap.set("n", "D", function()
  print("hi")
  local sha = u.get_word_under_cursor()
  vim.print(sha)
  vim.api.nvim_feedkeys(string.format(":DiffviewOpen origin/main...%s", sha), "n", false)
  u.press_enter()
end, map_opts)
