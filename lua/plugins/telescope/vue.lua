local u = require("functions.utils")

local M = {}
M.get_component_references = function()
  local bufName = vim.api.nvim_buf_get_name(0)
  local filename = u.basename(bufName)
  local componentParts = u.split(filename, ".vue")
  local component = componentParts[1]
  local componentStart = '<' .. component
  local builtin = require("telescope.builtin")
  builtin.grep_string({ search = componentStart })
end

-- Gets component references
vim.keymap.set("n", "<localleader>cr", function() M.get_component_references() end)
return M
