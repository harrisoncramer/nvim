local u = require("functions.utils")
local M = {}

vim.keymap.set("n", "<localleader>m", ":/methods: {<CR>")
vim.keymap.set("n", "<localleader>c", ":/computed: {<CR>")
vim.keymap.set("n", "<localleader>i", ":/import <CR>")
vim.keymap.set("n", "<localleader>p", ":/props: {<CR>")
vim.keymap.set("n", "<localleader>s", ":/<style <CR>")

-- Work-specific
M.make_or_jump_to_test_file = function()
  local file_path = u.copy_relative_filepath(true):gsub("src/", "")
  local file_name = u.copy_file_name(true):gsub(".vue", ".test.js")
  local path = "test/specs/" .. file_path .. file_name
  vim.cmd(string.format("e %s", path))
  if vim.fn.filereadable(path) == 0 then
    require("notify")("New test file created, please save")
  end
end

vim.keymap.set("n", "<localleader>t", M.make_or_jump_to_test_file)


M.import_from_vue = function(recurse)
  local ok = u.jump_to_line("from 'vue'")
  if ok then
    vim.api.nvim_feedkeys("f}h", "n", false)
    return
  end

  u.jump_to_line("<script ")
  vim.api.nvim_feedkeys("oimport {  } from 'vue'", "i", false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), 'n', false)
  vim.schedule(function()
    if recurse then -- If the previous line did not exist, we just run the shortcut again!
      M.import_from_vue(false)
    end
  end)
end

vim.keymap.set("n", "<localleader>vi", function()
  M.import_from_vue(true)
end)
