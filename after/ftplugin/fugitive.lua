local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }
local u = require("functions.utils")

-- vim.keymap.del("n", "<CR>")
vim.keymap.set("n", "<CR>", function()
  local sha = u.get_word_under_cursor()
  vim.print(sha)
  vim.api.nvim_feedkeys(string.format(":DiffviewOpen origin/main...%s", sha), "n", false)
  u.press_enter()
end, map_opts)
