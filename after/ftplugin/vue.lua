local u = require("functions.utils")
local M = {}

vim.keymap.set("n", "<localleader>m", ":/methods: {<CR>")
vim.keymap.set("n", "<localleader>c", ":/computed: {<CR>")
vim.keymap.set("n", "<localleader>i", ":/import <CR>")
vim.keymap.set("n", "<localleader>p", ":/props: {<CR>")
vim.keymap.set("n", "<localleader>s", ":/<style <CR>")

local get_component_references = function()
  local bufName = vim.api.nvim_buf_get_name(0)
  local filename = u.basename(bufName)
  local componentParts = u.split(filename, ".vue")
  local component = componentParts[1]
  local componentStart = '<' .. component
  local fzfLua = require("fzf-lua")
  fzfLua.grep_string({ search = componentStart })
end

-- Gets vue "reference" to current component (searches for <ComponentName) in telescope
vim.keymap.set("n", "<localleader>vr", function() get_component_references() end)

-- Work-specific
M.make_or_jump_to_test_file = function()
  local fp = u.copy_relative_filepath(true)
  local file_path = fp:gsub(".vue", ".test.js"):gsub("src/", "")
  local path = "test/specs/" .. file_path
  vim.cmd(string.format("e %s", path))
  if vim.fn.filereadable(path) == 0 then
    require("notify")("New test file created, please save")
  end
end

vim.keymap.set("n", "<localleader>tj", M.make_or_jump_to_test_file)


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
