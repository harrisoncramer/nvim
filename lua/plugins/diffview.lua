return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.opt.fillchars:append { diff = "╱" }
    local actions = require("diffview.actions")
    local diffview = require("diffview")
    local cb = require("diffview.config").diffview_callback

    -- See lua/git-helpers/ for keybindings...

    diffview.setup({
      view = {
        default = {
          winbar_info = false,
        },
        file_history = {
          winbar_info = false,
        },
      },
      win_config = function()
        return {
          type = "split",
          position = "bottom",
          height = 14,
          relative = "win",
          win = vim.api.nvim_tabpage_list_wins(0)[1],
        }
      end,
      diff_binaries = false,
      use_icons = true, -- Requires nvim-web-devicons
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = { fold_closed = "", fold_open = "" },
      file_panel = {
        listing_style = "tree", -- One of 'list' or 'tree'
        tree_options = {
          -- Only applies when listing_style is 'tree'
          flatten_dirs = true,             -- Flatten dirs that only contain one single dir
          folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
        },
      },
      enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
      default_args = {
        -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {
          -- Follow only the first parent upon seeing a merge commit.
          first_parent = true,
          -- Include all refs.
          all = true,
          -- List only merge commits.
          merges = false,
          -- List commits in reverse order.
          reverse = false,
        },
      },
      hooks = {},                -- See ':h diffview-config-hooks'
      key_bindings = {
        disable_defaults = true, -- Disable the default key bindings
        -- The `view` bindings are active in the diff buffers, only when the current
        -- tabpage is a Diffview.
        view = {
          ["<C-n>"] = cb("select_next_entry"),    -- Open the diff for the next file
          ["<C-p>"] = cb("select_prev_entry"),    -- Open the diff for the previous file
          ["<CR>"] = cb("goto_file_edit"),        -- Open the file in a new split in previous tabpage
          ["<C-w><C-f>"] = cb("goto_file_split"), -- Open the file in a new split
          ["<C-w>gf"] = cb("goto_file_tab"),      -- Open the file in a new tabpage
          ["<leader>e"] = cb("focus_files"),      -- Bring focus to the files panel
          ["<leader>b"] = cb("toggle_files"),     -- Toggle the files panel.
        },
        file_panel = {
          ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
          ["<down>"] = cb("next_entry"),
          ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
          ["<up>"] = cb("prev_entry"),
          ["o"] = cb("select_entry"),
          ["<2-LeftMouse>"] = cb("select_entry"),
          ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
          ["S"] = cb("stage_all"),          -- Stage all entries.
          ["U"] = cb("unstage_all"),        -- Unstage all entries.
          ["X"] = cb("restore_entry"),      -- Restore entry to the state on the left side.
          ["R"] = cb("refresh_files"),      -- Update stats and entries in the file list.
          ["<S-Up>"] = actions.scroll_view(-20),
          ["<S-Down>"] = actions.scroll_view(20),
          ["<C-n>"] = cb("select_next_entry"),
          ["<C-p>"] = cb("select_prev_entry"),
          ["gf"] = cb("goto_file"),
          ["<cr>"] = cb("goto_file_tab"),
          ["i"] = cb("listing_style"),       -- Toggle between 'list' and 'tree' views
          ["f"] = cb("toggle_flatten_dirs"), -- Flatten empty subdirectories in tree listing style.
          ["<leader>e"] = cb("focus_files"),
        },
        file_history_panel = {
          ["g!"] = cb("options"),               -- Open the option panel
          ["<C-A-d>"] = cb("open_in_diffview"), -- Open the entry under the cursor in a diffview
          ["zR"] = cb("open_all_folds"),
          ["zM"] = cb("close_all_folds"),
          ["j"] = cb("next_entry"),
          ["<down>"] = cb("next_entry"),
          ["k"] = cb("prev_entry"),
          ["<up>"] = cb("prev_entry"),
          ["<cr>"] = cb("select_entry"),
          ["o"] = cb("select_entry"),
          ["<2-LeftMouse>"] = cb("select_entry"),
          ["<C-n>"] = cb("select_next_entry"),
          ["<C-p>"] = cb("select_prev_entry"),
          ["gf"] = cb("goto_file"),
          ["<C-w><C-f>"] = cb("goto_file_split"),
          ["<C-w>gf"] = cb("goto_file_tab"),
          ["<leader>e"] = cb("focus_files"),
          ["<leader>b"] = cb("toggle_files"),
        },
        option_panel = { ["<tab>"] = cb("select"), ["q"] = cb("close") },
      },
    })
  end
}
