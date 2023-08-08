local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }
return {
  "nvim-telescope/telescope.nvim",
  requires = { "nvim-lua/plenary.nvim", "junegunn/fzf", },
  dependencies = { "nvim-telescope/telescope-file-browser.nvim" },
  config = function()
    local actions = require("telescope.actions")
    local state = require("telescope.actions.state")
    local u = require("functions.utils")
    local fb_actions = require("telescope").extensions.file_browser.actions
    local telescope = require("telescope")

    local builtin = require("telescope.builtin")

    -- Utility functions for file_browser extension
    local function FbOpen(file_path, open_file)
      local entry_path = u.dirname(file_path)
      if string.sub(entry_path, -1, -1) == "/" then
        entry_path = string.sub(entry_path, 1, -2)
      end
      require("telescope").extensions.file_browser.file_browser({ path = entry_path, quiet = true })
      -- if open_file then
      --   vim.api.nvim_input(u.basename(entry))
      -- end
    end

    local function OpenInFileBrowser(prompt_bufnr)
      actions._close(prompt_bufnr, true)
      local entry = state.get_selected_entry()[1]
      local split = u.split(entry, ":")
      local file_path = split[1]
      FbOpen(file_path, true)
    end

    local function OpenFileInFileBrowser()
      local file_path = vim.fn.expand("%")
      FbOpen(file_path, true)
    end

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

    local function grep_string_visual()
      local text = u.get_visual_selection()
      if text == nil then
        require("notify")("No visual selection found", "error")
        return
      end


      if text[1] == "" or text[1] == nil then
        require("notify")("No visual selection found", "error")
        return
      end

      builtin.grep_string({ search = text[1] })
    end

    local function current_buffer_fuzzy_find()
      require("telescope.builtin").current_buffer_fuzzy_find()
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

    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        file_browser = {
          layout_strategy = "horizontal",
          layout_config = {
            preview_width = .60,
          },
          quiet = true,
          hijack_netrw = true,
          hide_parent_dir = true,
          hidden = true,
          mappings = {
            i = {
              [","] = fb_actions.goto_parent_dir,
              ["<C-e>"] = fb_actions.create,
              ["<C-y>"] = fb_actions.copy,
              ["<C-k>"] = fb_actions.remove,
              ["<C-r>"] = function(bufnr)
                fb_actions.rename(bufnr)
              end,
              ["<C-x>"] = fb_actions.move,
            },
          },
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
              ["<C-h>"] = OpenInFileBrowser,
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
              ["<C-h>"] = OpenInFileBrowser,
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
        current_buffer_fuzzy_find = {
          previewer = false,
          sorting_strategy = "ascending",
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
    vim.keymap.set("n", "<C-c>", current_buffer_fuzzy_find, {})
    vim.keymap.set("n", "<C-j>", git_files, {})
    vim.keymap.set("n", "<C-m>", telescope.extensions.file_browser.file_browser, { silent = true, noremap = true })
    vim.keymap.set("n", "<C-n>", ":Telescope buffers<CR>")
    vim.keymap.set("n", "<leader>tgc", git_commits, {})
    vim.keymap.set("n", "<leader>tgb", git_branches, {})
    vim.keymap.set("n", "<leader>tf", grep_string, {})
    vim.keymap.set("v", "<leader>tf", grep_string_visual, {})
    vim.keymap.set("n", "<leader>tj", find_matching_files)
    vim.keymap.set("n", "<C-h>", OpenFileInFileBrowser)

    -- telescope.load_extension("fzf")
    telescope.load_extension("file_browser")

    -- Custom Pickers
    require("plugins.telescope.pickers")

    vim.keymap.set("n", "HOH", ":neat", map_opts)
    -- Custom mappings per use-case
    require("plugins.telescope.vue")
  end
}
