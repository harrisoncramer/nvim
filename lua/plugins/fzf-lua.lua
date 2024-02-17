local u = require("functions.utils")

local find_matching_files = function()
  local bare_file_name = u.return_bare_file_name()
  require("fzf-lua").git_files({ search = bare_file_name, no_esc = true })
end

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzfLua = require("fzf-lua")
    local actions = require("fzf-lua.actions")
    fzfLua.setup({
      winopts = {
        -- fullscreen = true,
        preview = {
          layout   = 'vertical',
          vertical = 'up:70%', -- up|down:size
        }
      },
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
          prompt = "> ",
          cmd = 'git ls-files --exclude-standard --others --cached',
        }
      },
      previewers = {
        builtin = {
          extensions = {
            ["png"] = { "viu", "-b" },
          }
        }
      },
      keymap = {
        fzf = {
          ["ctrl-z"] = "abort",
          ["ctrl-s"] = "select-all",
          ["f3"] = "toggle-preview-wrap",
          ["f4"] = "toggle-preview",
          ["shift-down"] = "preview-page-down",
          ["shift-up"] = "preview-page-up",
        },
      }
    })
    vim.keymap.set("n", "<C-j>", fzfLua.git_files)
    vim.keymap.set("n", "<C-m>", function()
      fzfLua.git_files({ cmd = "git diff --name-only main && git ls-files --exclude-standard --others" })
    end, {})
    vim.keymap.set("n", "<C-f>", fzfLua.live_grep_native)
    vim.keymap.set("n", "<leader>tgc", fzfLua.git_commits, {})
    vim.keymap.set("n", "<leader>tgb", fzfLua.git_branches, {})
    vim.keymap.set("n", "<leader>tj", find_matching_files)
  end
}
