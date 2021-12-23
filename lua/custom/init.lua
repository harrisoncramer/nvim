local ts_utils = require("nvim-treesitter.ts_utils")
local M = {}

local get_parent = function (node)
  local prev = ts_utils.get_previous_node(node, true, true)
  while(prev:parent() == node:parent()) do
    node = prev
    if(ts_utils.get_previous_node(prev, true, true) == nil) then
      -- If we're at the last node...
      return node
    end
    prev = ts_utils.get_previous_node(prev, true, true)
  end

  return node

end

local get_master_node = function ()
  local node = ts_utils.get_node_at_cursor()
  if node == nil then
    error("No Treesitter parser found.")
  end

  local start_row = node:start()
  local parent = node:parent()

  while(parent ~= nil and parent:start() == start_row) do
    node = parent
    parent = node:parent()
  end

  return node
end

M.parent = function ()
  local node = get_master_node()
  local parent = get_parent(node)
  local bufnr = vim.api.nvim_get_current_buf()
  ts_utils.goto_node(parent)
end

return M
