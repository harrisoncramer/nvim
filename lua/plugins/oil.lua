local u = require("functions.utils")

local file

local M = {
  'stevearc/oil.nvim',
  config = function()
    vim.keymap.set("n", "<C-h>", function()
      vim.opt.splitright = false
      vim.cmd.vsplit()
      vim.opt.splitright = true
      local path = vim.fn.expand("%:p")
      local dir = u.dirname(path)
      file = u.basename(path)
      require("oil").open(dir)
    end, { desc = "Open parent directory" })
    require("oil").setup({
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
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
      },
      view_options = {
        show_hidden = true,
      }
    })
  end,
  dependencies = { "kyazdani42/nvim-web-devicons" },
}

vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local oil = require("oil")
    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      u.jump_to_line(file)
    end
  end),
})

return M
