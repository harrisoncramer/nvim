return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzfLua = require("fzf-lua")
    local actions = require("fzf-lua.actions")
    fzfLua.setup({
      winopts = {
        preview = {
          layout   = 'vertical',
          vertical = 'up:70%', -- up|down:size
        }
      },
      actions = {
        files = {
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-q"]  = actions.file_sel_to_qf,
          ["ctrl-v"]  = actions.file_vsplit,
          ["ctrl-t"]  = actions.file_tabedit,
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
          false,
          ["ctrl-z"] = "abort",
          ["ctrl-o"] = "select-all",
          -- TODO: Want to change to <C-u> and <C-d> but they aren't working
          ["shift-down"] = "preview-page-down",
          ["shift-up"] = "preview-page-up",
        },
      }
    })
    vim.keymap.set("n", "<C-j>", fzfLua.git_files)
    vim.keymap.set("n", "<C-g><C-j>", function()
      fzfLua.git_files({ resume = true })
    end)

    -- Searches only in directory of current service
    vim.keymap.set("n", "<C-m>", function()
      local root_dir = vim.fn.getcwd()
      local cmd = "git ls-files --exclude-standard " .. root_dir
      fzfLua.git_files({ cmd = cmd })
    end, {})

    vim.keymap.set("n", "<C-f>", fzfLua.live_grep_native)
    vim.keymap.set("n", "<C-g><C-f>", function()
      fzfLua.live_grep_native({ resume = true })
    end)
  end
}
