local map_opts = { noremap = true, silent = true, nowait = true }
local u = require("functions.utils")
local diffview = require("diffview")
local popup = require("popup")

local job = require('plenary.job')
local M = {}

vim.keymap.set("n", "<leader>gcc", function() M.easy_commit() end, map_opts)
vim.keymap.set("n", "<leader>gaa", function() M.add_all() end, map_opts)
vim.keymap.set("n", "<leader>gac", function() M.add_current() end, map_opts)
vim.keymap.set("n", "<leader>gcm", function() M.commit() end, map_opts)
vim.keymap.set("n", "<leader>gre", function() M.reset_easy_commits() end, map_opts)
vim.keymap.set("n", "<leader>gss", function() M.stash() end, map_opts)
vim.keymap.set("n", "<leader>gsp", function() M.pop() end, map_opts)
vim.keymap.set("n", "<leader>gfh", function() M.git_file_history() end, map_opts)
vim.keymap.set("n", "<leader>gu", function() M.view_uncommitted() end, map_opts)

-- Commits the changes in a file quickly with a message "Updated %s"
M.easy_commit = function()
  local relative_file_path = u.copy_relative_filepath(true)
  job:new({
    command = 'git',
    args = { "commit", relative_file_path, "-m", string.format("Updated %s", relative_file_path) },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not commit change!', vim.log.levels.ERROR)
        return
      else
        require("notify")('Committed file', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Stashes all uncommitted changes in the current branch (git stash)
M.stash = function()
  job:new({
    command = 'git',
    args = { "stash" },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not stash changes!', vim.log.levels.ERROR)
        return
      else
        require("notify")('Stashed', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Stages all changes (git add .)
M.add_all = function()
  job:new({
    command = 'git',
    args = { "add", ".", },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not add all files!', vim.log.levels.ERROR)
        return
      else
        require("notify")('Added all files', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Stages current file (git add FILENAME)
M.add_current = function()
  local relative_file_path = u.copy_relative_filepath(true)
  job:new({
    command = 'git',
    args = { "add", relative_file_path },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")(string.format('Could not add %s!', relative_file_path), vim.log.levels.ERROR)
        return
      else
        require("notify")('Added current file', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Resets all recent easy commits softly, used in combination with add_all() and commit() to squash
-- easy commits into readable commit message
M.reset_easy_commits = function()
  local latest_non_easy_commit = io.popen(
    "git log --format=\"%s %H\" | grep -v \"^Updated \" | awk '{ print $NF }' | tail -n +1 | head -1")
  if latest_non_easy_commit == nil then
    require("notify")('No easy commit hash found', vim.log.levels.ERROR)
    return
  end

  local non_easy_hash = vim.fn.trim(latest_non_easy_commit:read("*a"))
  latest_non_easy_commit:close()

  job:new({
    command = 'git',
    args = { 'reset', '--soft', non_easy_hash },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not reset easy commits softly!', vim.log.levels.ERROR)
        return
      else
        require("notify")('Soft reset all easy commits', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Opens a popup in order to write a commit message
M.commit = function()
  popup.create_popup_with_action("Commit Message", function(msg)
    job:new({
      command = 'git',
      args = { 'commit', '-m', msg },
      on_exit = vim.schedule_wrap(function(_, exit_code)
        if exit_code ~= 0 then
          require("notify")('Could not commit changes with message!', vim.log.levels.ERROR)
          return
        else
          require("notify")('Committed changes', vim.log.levels.INFO)
        end
      end),
    }):start()
  end)
end

-- Pops stashed changes (git stash pop)
M.pop = function()
  job:new({
    command = 'git',
    args = { 'stash', 'pop' },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not pop off stash!', vim.log.levels.ERROR)
        return
      else
        require("notify")('Popped', vim.log.levels.INFO)
      end
    end),
  }):start()
end

M.get_branch_name = function()
  local is_git_branch = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read("*a")
  if is_git_branch == "true\n" then
    for line in io.popen("git branch 2>/dev/null"):lines() do
      local current_branch = line:match("%* (.+)$")
      if current_branch then
        return current_branch
      end
    end
  end
end

M.get_root_git_dir = function()
  local cur_path = vim.fn.expand("%:p")
  local dir = vim.fs.find(".git", {
    path = cur_path,
    upward = true,
    type = "directory"
  })[1]
  if dir == nil then return dir end
  return dir:sub(1, -5)
end

M.branch_exists = function(b)
  local is_git_branch = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read("*a")
  if is_git_branch == "true\n" then
    for line in io.popen("git branch 2>/dev/null"):lines() do
      line = line:gsub("%s+", "")
      if line == b then
        return true
      end
    end
  end
  return false
end

-- Toggle file history of this file
M.git_file_history = function()
  local isDiff = vim.fn.getwinvar(nil, "&diff")
  local bufName = vim.api.nvim_buf_get_name(0)
  diffview.FOCUSED_HISTORY_FILE = bufName
  if isDiff ~= 0 or u.string_starts(bufName, "diff") then
    diffview.FOCUSED_HISTORY_FILE = nil
    vim.cmd.bd()
    vim.cmd.tabprev()
  else
    vim.api.nvim_feedkeys(":DiffviewFileHistory " .. vim.fn.expand("%"), "n", false)
    u.press_enter()
  end
end

-- Toggle viewing all uncommitted changes (current diff)
M.view_uncommitted = function()
  local isDiff = vim.fn.getwinvar(nil, "&diff")
  local bufName = vim.api.nvim_buf_get_name(0)
  if isDiff ~= 0 or u.string_starts(bufName, "diff") then
    vim.cmd.bd()
    vim.cmd.tabprev()
  else
    vim.cmd.DiffviewOpen()
    u.press_enter()
  end
end

return M
