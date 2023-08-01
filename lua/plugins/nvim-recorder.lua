local popup = require("plenary.popup")

vim.keymap.set("n", "<leader>qo", function() MyMenu() end, {}) -- Show macros

local window_id
function ShowMenu(opts, cb)
  local height = 20
  local width = 100
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

  local content = {}
  local array_length = #opts
  for i, value in ipairs(opts) do
    if i < array_length then
      local new_string = value:gsub("\n", "")
      local str = new_string:find('"')
      if str then new_string = new_string:sub(str + 1) end
      table.insert(content, new_string)
    end
  end


  window_id = popup.create(content, {
    title = "Macros",
    highlight = "MyProjectWindow",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
    callback = cb,
  })
  local bufnr = vim.api.nvim_win_get_buf(window_id)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>lua CloseMenu()<CR>", { silent = false })
end

local function get_multiple_registers_content(registers)
  local reg_content_array = {}
  local saved_reg_content = vim.fn.getreg('@')

  for i, register in ipairs(registers) do
    vim.cmd('redir => reg_content')
    vim.cmd('silent execute "reg ' .. register .. '"')
    vim.cmd('redir END')
    print('evaling: ' .. register)
    reg_content_array[i] = vim.fn.eval('reg_content')
  end

  vim.fn.setreg('@', saved_reg_content)
  return reg_content_array
end

local function get_register(input_string)
  local character_before_blank = input_string:match("([a-g])%s")
  return character_before_blank
end

local registers = { 'a', 'b', 'c', 'd', 'e', 'f', 'g' } -- The macro slots and registers
function MyMenu()
  local opts = get_multiple_registers_content(registers)
  local cb = function(_, sel)
    local macro_register = get_register(sel)
    local cmd = '@' .. macro_register
    vim.api.nvim_feedkeys(cmd, 'n', true)
  end
  ShowMenu(opts, cb)
end

return {
  "chrisgrieser/nvim-recorder",
  dependencies = "rcarriga/nvim-notify", -- optional
  opts = {
    slots = registers,
    mapping = {
      startStopRecording = "q",
      playMacro = "Q",
      editMacro = "<leader>qe",
      switchSlot = "<leader>qt",
    },
    clear = false,
    logLevel = vim.log.levels.INFO,
    dapSharedKeymaps = false,
  }
}
