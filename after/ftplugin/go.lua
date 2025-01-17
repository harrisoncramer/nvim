local u = require("functions.utils")

local function add_json_tag()
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]

  -- Extract the first word (field name)
  local field_name = u.get_first_word()
  if not field_name then
    print("Could not determine field name.")
    return
  end

  -- Convert field name to snake_case
  local json_key = u.pascal_to_snake_case(field_name)

  -- Append JSON tag
  local new_line = line:gsub("%s*$", "") .. string.format(' `json:"%s"`', json_key)

  -- Update line in buffer
  vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_line })
end

vim.keymap.set("n", "<leader>jt", add_json_tag)
