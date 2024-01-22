local u = require("functions.utils")

local find_matching_files = function()
  local bare_file_name = u.return_bare_file_name()
  require("fzf-lua").git_files({ search = bare_file_name, no_esc = true })
end

return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzfLua = require("fzf-lua")
    local actions = require("fzf-lua.actions")
    fzfLua.setup({
      actions = {
        files = {
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-q"]  = actions.file_sel_to_qf,
        }
      },
      fzf_opts = {
        ["--layout"] = false
      },
      git = {
        files = {
          prompt = "> "
        }
      },
      keymap = {
        builtin = {
          -- ["ctrl-d"] = "preview-page-down",
          -- ["ctrl-u"] = "preview-page-up",
        }
      }
    })
    vim.keymap.set("n", "<C-j>", fzfLua.git_files)
    vim.keymap.set("n", "<C-f>", fzfLua.live_grep)
    vim.keymap.set("n", "<leader>tgc", fzfLua.git_commits, {})
    vim.keymap.set("n", "<leader>tgb", fzfLua.git_branches, {})
    vim.keymap.set("n", "<leader>tj", find_matching_files)
  end
}
