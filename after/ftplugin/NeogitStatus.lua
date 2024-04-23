local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }
vim.keymap.set("n", "<leader>gs", function()
  print("Hi")
  vim.cmd.tabclose()
end, map_opts)
