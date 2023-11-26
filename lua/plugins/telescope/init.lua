local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }
return {
  "nvim-telescope/telescope.nvim",
  requires = { "nvim-lua/plenary.nvim", "junegunn/fzf", },
  config = function()
    local actions = require("telescope.actions")
    local state = require("telescope.actions.state")
    local u = require("functions.utils")
    local telescope = require("telescope")

    local builtin = require("telescope.builtin")

    local function find_matching_files()
      local bare_file_name = u.return_bare_file_name()
      require("telescope.builtin").find_files({ default_text = bare_file_name })
    end

    -- Functions for telescope
    local function live_grep()
      builtin.live_grep()
    end

    local function git_files()
      local ok = pcall(builtin.git_files)
      if not ok then
        require("telescope.builtin").find_files()
      end
    end

    local function git_commits()
      builtin.git_commits()
    end

    local function git_branches()
      builtin.git_branches()
    end

    local function grep_string()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string()
      vim.api.nvim_feedkeys(word, "i", false)
    end

    local function SeeCommitChangesInDiffview(prompt_bufnr)
      actions.close(prompt_bufnr)
      local value = state.get_selected_entry().value
      vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
    end

    local function CompareWithCurrentBranchInDiffview(prompt_bufnr)
      actions.close(prompt_bufnr)
      local value = state.get_selected_entry().value
      vim.cmd("DiffviewOpen " .. value)
    end

    local function CopyTextFromPreview(prompt_bufnr)
      local selection = require("telescope.actions.state").get_selected_entry()
      local text = vim.fn.trim(selection["text"])
      local os = u.get_os() == "Darwin" and "mac" or "linux"
      if os == "mac" then
        vim.fn.setreg('*', text)
      else
        vim.fn.setreg('"', text)
      end
      actions.close(prompt_bufnr)
    end

    local function CopyCommitHash(prompt_bufnr)
      local selection = require("telescope.actions.state").get_selected_entry()
      local os = u.get_os() == "Darwin" and "mac" or "linux"
      if os == "mac" then
        vim.fn.setreg('*', selection.value)
      else
        vim.fn.setreg('"', selection.value)
      end
      actions.close(prompt_bufnr)
    end

    local function SendToQuickfix(bufnr)
      actions.smart_add_to_qflist(bufnr)
      actions.open_qflist(bufnr)
    end

    local function OpenInOil()
      local selection = require("telescope.actions.state").get_selected_entry()
      require("plugins.oil").open_dir(selection.value)
    end

    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
      defaults = {
        border = true,
        layout_strategy = "horizontal",
        file_ignore_patterns = { "node_modules", "package%-lock.json" },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<Down>"] = actions.cycle_history_next,
            ["<Up>"] = actions.cycle_history_prev,
          },
        },
      },
      pickers = {
        live_grep = {
          layout_strategy = "vertical",
          layout_config = {
            preview_height = .35,
          },
          use_regex = false,
          only_sort_text = true,
          prompt_prefix = " ",
          mappings = {
            i = {
              ["<C-y>"] = CopyTextFromPreview,
              ['<C-q>'] = SendToQuickfix,
            },
          },
        },
        git_files = {
          layout_strategy = "horizontal",
          layout_config = {
            preview_width = .60,
          },
          show_untracked = true,
          mappings = {
            i = {
              ["<C-o>"] = OpenInOil,
            },
          },
        },
        git_branches = {
          layout_strategy = "vertical",
          -- layout_config = {
          --   preview_width = .60,
          -- },
          prompt_prefix = " ",
        },
        buffers = {
          hidden = true,
        },
        git_commits = {
          layout_strategy = "horizontal",
          layout_config = {
            preview_width = .60,
          },
          prompt_prefix = " ",
          mappings = {
            i = {
              ["<C-y>"] = CopyCommitHash,
              ["<C-o>"] = SeeCommitChangesInDiffview,
              ["<C-d><C-f>"] = CompareWithCurrentBranchInDiffview,
            },
          },
        },
      },
    })

    vim.keymap.set("n", "<C-f>", live_grep, {})
    vim.keymap.set("n", "<C-j>", git_files, {})
    vim.keymap.set("n", "<leader>tgc", git_commits, {})
    vim.keymap.set("n", "<leader>tgb", git_branches, {})
    vim.keymap.set("n", "<leader>tf", grep_string, {})
    vim.keymap.set("n", "<leader>tj", find_matching_files)

    -- Custom Pickers
    require("plugins.telescope.pickers")

    -- Custom mappings per use-case
    require("plugins.telescope.vue")
  end
}
