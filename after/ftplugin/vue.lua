local u = require("functions.utils")

vim.keymap.set("n", "<localleader>m", ":/methods: {<CR>")
vim.keymap.set("n", "<localleader>c", ":/computed: {<CR>")
vim.keymap.set("n", "<localleader>i", ":/import <CR>")
vim.keymap.set("n", "<localleader>p", ":/props: {<CR>")
vim.keymap.set("n", "<localleader>s", ":/<style <CR>")

-- Work-specific
local make_or_jump_to_test_file = function()
  local file_path = u.copy_relative_filepath(true):gsub("src/", "")
  local file_name = u.copy_file_name(true):gsub(".vue", ".test.js")
  local path = "test/specs/" .. file_path .. file_name
  vim.cmd(string.format("e %s", path))
  if vim.fn.filereadable(path) == 0 then
    require("notify")("New test file created, please save")
  end
end

vim.keymap.set("n", "<localleader>t", make_or_jump_to_test_file)
