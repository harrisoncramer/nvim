local entry_display = require("telescope.pickers.entry_display")
local u = require("functions.utils")
local actions = require("telescope.actions")
local utils = require("telescope.utils")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local Path = require("plenary.path")
local os_sep = Path.path.sep
local scan = require("plenary.scandir")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local stash_filter = function()
  local opts = { show_branch = false }
  opts.show_branch = vim.F.if_nil(opts.show_branch, true)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_stash(opts))

  pickers.new(opts, {
    prompt_title = "Git Stash",
    finder = finders.new_oneshot_job({ "git", "--no-pager", "stash", "list" }, opts),
    previewer = previewers.git_stash_diff.new(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(actions.git_apply_stash)
      return true
    end,
  }):find()
end

local live_grep_in_directory = function(opts)
  opts = opts or {}
  local data = {}
  scan.scan_dir(vim.loop.cwd(), {
    hidden = opts.hidden,
    only_dirs = true,
    respect_gitignore = opts.respect_gitignore,
    on_insert = function(entry)
      table.insert(data, entry .. os_sep)
    end,
  })
  table.insert(data, 1, "." .. os_sep)
  pickers.new(opts, {
    prompt_title = "Directories for Live Grep",
    layout_strategy = "horizontal",
    layout_config = {
      preview_width = .60,
    },
    finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      action_set.select:replace(function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local dirs = {}
        local selections = current_picker:get_multi_selection()
        if vim.tbl_isempty(selections) then
          table.insert(dirs, action_state.get_selected_entry().value)
        else
          for _, selection in ipairs(selections) do
            table.insert(dirs, selection.value)
          end
        end
        actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
        require("telescope.builtin").live_grep({ search_dirs = dirs })
      end)
      return true
    end,
  }):find()
end

function make_entry.gen_from_git_stash(opts)
  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 10 },
      opts.show_branch and { width = 15 } or "",
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.value, "TelescopeResultsLineNr" },
      opts.show_branch and { entry.branch_name, "TelescopeResultsIdentifier" } or "",
      entry.commit_info,
    })
  end

  return function(entry)
    if entry == "" then
      return nil
    end

    local splitted = utils.max_split(entry, ": ", 2)
    local stash_idx = splitted[1]
    local _, commit_branch_name = string.match(splitted[2], "^([WIP on|On]+) (.+)")
    local commit_info = splitted[3]

    local real_branch = u.get_branch_name()
    local escaped_commit_branch_name = u.escape_string(commit_branch_name)

    local search = string.find(real_branch, escaped_commit_branch_name)
    if search == nil then
      return nil
    end

    return {
      value = stash_idx,
      ordinal = commit_info,
      branch_name = commit_branch_name,
      commit_info = commit_info,
      display = make_display,
    }
  end
end

vim.keymap.set("n", "<C-g>", live_grep_in_directory, {})
vim.keymap.set("n", "<leader>tgs", stash_filter, {})
