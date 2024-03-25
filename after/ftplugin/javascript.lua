local M = {}
local u = require("functions.utils")

-- Work-specific
M.jump_to_source_file = function()
  local fp = u.copy_relative_filepath(true)
  if string.match(fp, ".test.js") then
    local file_path = fp:gsub(".test.js", ".vue"):gsub("test/specs", "src")
    vim.cmd(string.format("e %s", file_path))
  end
end

vim.keymap.set("n", "<localleader>tj", M.jump_to_source_file)

return M
