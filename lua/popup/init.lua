local u = require("functions.utils")
local M = {}

local popup_ok, Popup = pcall(require, "nui.popup")
if not popup_ok then
  vim.api.nvim_err_writeln("Nui not installed, cannot configure popups!")
  return
end

M.create_popup_state = function(title)
  local view_opts = {
    buf_options = {
      filetype = "markdown",
    },
    relative = "editor",
    enter = true,
    focusable = true,
    zindex = 50,
    border = {
      style = "rounded",
      text = {
        top = title,
      },
    },
    position = "50%",
    size = {
      width = "40%",
      height = "60%"
    },
    opacity = 1.0
  }
  return view_opts
end

M.create_popup_with_action = function(title, action)
  local popup = Popup(M.create_popup_state(title))
  popup:mount()
  vim.keymap.set("n", "<leader>s", function()
    local text = u.get_buffer_text(0)
    popup:unmount()
    if action ~= nil then
      action(text)
    end
  end, { buffer = popup.bufnr, desc = "Exit popup and do action" })
end

return M
