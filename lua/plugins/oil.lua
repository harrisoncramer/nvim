local u = require("functions.utils")
local open_dir = function(path)
  local dir = u.dirname(path)
  require("oil").open_float(dir)
end

local M = {
  'stevearc/oil.nvim',
  config = function()
    vim.keymap.set("n", "<C-h>", function()
      local current_path = vim.fn.expand("%")
      open_dir(current_path)
    end, { desc = "Open parent directory" })
    require("oil").setup({
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    })
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

M.open_dir = open_dir


return M
