local u = require("functions.utils")

local find_matching_files = function()
  local bare_file_name = u.return_bare_file_name()
  require("fzf-lua").git_files({}, bare_file_name)
end

return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzfLua = require("fzf-lua")
    fzfLua.setup({
      preview = {
        keymap = {
          builtin = {
            ["<C-a>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
          }
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
