local M = {}
local map_opts = { noremap = true, silent = true, nowait = true }
local u = require("functions.utils")
local popup = require("popup")

local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
local diffview_ok, diffview = pcall(require, "diffview")
local plenary_ok, job = pcall(require, "plenary.job")

if not gitsigns_ok or not diffview_ok or not plenary_ok then
  vim.api.nvim_err_writeln("Gitsigns, diffview, or plenary not installed, cannot configure Git tools")
  return
end

-- Hunk-level operations
vim.keymap.set("n", "<leader>ghn", function() -- Next Change
  gitsigns.next_hunk()
  gitsigns.preview_hunk()
end)
vim.keymap.set("n", "<leader>ghp", function() -- Next Change
  gitsigns.prev_hunk()
  gitsigns.preview_hunk()
end)
vim.keymap.set("n", "<leader>ghr", gitsigns.reset_hunk) -- Reset Hunk
vim.keymap.set("n", "<leader>gha", gitsigns.stage_hunk) -- Add hunk
vim.keymap.set("n", "<leader>ghv", gitsigns.preview_hunk)

-- Adding files...
vim.keymap.set("n", "<leader>gaa", function() M.add_all() end, map_opts)
vim.keymap.set("n", "<leader>gah", gitsigns.stage_hunk)
vim.keymap.set("n", "<leader>gac", function() M.add_current() end, map_opts)

-- Committing changes...
vim.keymap.set("n", "<leader>gcm", function() M.commit() end, map_opts)
vim.keymap.set("n", "<leader>gce", function() M.commit_easy() end, map_opts)

-- Resetting changes...
vim.keymap.set("n", "<leader>gre", function() M.reset_easy_commits() end, map_opts)
vim.keymap.set("n", "<leader>grr", function() M.reset() end, map_opts)

-- Stashing and unstashing...
vim.keymap.set("n", "<leader>gss", function() M.stash() end, map_opts)
vim.keymap.set("n", "<leader>gsp", function() M.pop() end, map_opts)

-- Viewing changes and diffs...
vim.keymap.set("n", "<leader>gvc", function() M.view_changes() end, map_opts)
vim.keymap.set("n", "<leader>gvs", function() M.view_staged() end, map_opts)
vim.keymap.set("n", "<leader>gvfh", function() M.view_file_history() end, map_opts)

-- Miscellaneous...
vim.keymap.set("n", "<leader>gb", gitsigns.blame_line)
vim.keymap.set("n", "<leader>gq", function() gitsigns.setqflist("all") end)

-- Pushing and pulling...
vim.keymap.set("n", "<leader>gPP", function() M.push() end, map_opts)
vim.keymap.set("n", "<leader>gPU", function() M.pull() end, map_opts)

-- Commits the changes in a file quickly with a message "Updated %s"
M.commit_easy = function()
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
    args = { "add", "." },
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

-- Unstages all changes (git reset)
M.reset = function()
  job:new({
    command = 'git',
    args = { "reset" },
    on_exit = vim.schedule_wrap(function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")('Could not reset staged changes', vim.log.levels.ERROR)
        return
      else
        require("notify")('Unstaged all changes', vim.log.levels.INFO)
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
    require("notify")('No easy commit hash found!', vim.log.levels.ERROR)
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
          require("notify")('Committed.', vim.log.levels.INFO)
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
        require("notify")('Popped.', vim.log.levels.INFO)
      end
    end),
  }):start()
end

-- Push changes (git push)
M.push = function()
  local push_job = job:new({
    command = 'git',
    args = { 'push' },
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")("Could not push!", "error")
        return
      else
        require("notify")("Pushed.", "info")
      end
    end,
  })

  local isSubmodule = vim.fn.trim(vim.fn.system("git rev-parse --show-superproject-working-tree"))
  if isSubmodule == "" then
    push_job:start()
  else
    vim.fn.confirm("Push to origin/main branch for submodule?")
    push_job:start()
  end
end

-- Pull changes from remote (git pull)
M.pull = function()
  local pull_job = job:new({
    command = 'git',
    args = { 'pull' },
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        require("notify")("Could not pull!", "error")
        return
      else
        require("notify")("Pulled.", "info")
      end
    end,
  })

  pull_job:start()
end

M.is_inside_work_tree = function(cb)
  local branch_name_job = job:new({
    command = 'git',
    args = { 'rev-parse', '--is-inside-work-tree' },
    on_stdout = vim.schedule_wrap(function(err, data)
      if err == nil and data == "true" then
        cb()
      end
    end)
  })

  branch_name_job:start()
end

M.is_feature_branch = function(cb)
  local branch_name_job = job:new({
    command = 'git',
    args = { 'branch', '--show-current' },
    on_stdout = vim.schedule_wrap(function(err, branch_name)
      if err == nil and branch_name ~= nil then
        if branch_name ~= "main" and branch_name ~= "master" then
          cb(branch_name)
        end
      end
    end)
  })

  branch_name_job:start()
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
M.view_file_history = function()
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

-- Toggle viewing all unstaged changes (current diff)
M.view_changes = function()
  local isDiff = vim.fn.getwinvar(0, "&diff")
  local bufName = vim.api.nvim_buf_get_name(0)
  if isDiff ~= 0 or u.string_starts(bufName, "diff") then
    vim.cmd.bd()
    vim.cmd.tabprev()
  else
    vim.cmd("DiffviewOpen")
    u.press_enter()
  end
end

-- Toggle viewing all uncommitted changes (current diff)
M.view_staged = function()
  local isDiff = vim.fn.getwinvar(0, "&diff")
  local bufName = vim.api.nvim_buf_get_name(0)
  if isDiff ~= 0 or u.string_starts(bufName, "diff") then
    vim.cmd.bd()
    vim.cmd.tabprev()
  else
    vim.cmd("DiffviewOpen --staged")
    u.press_enter()
  end
end

M.get_remote_url = function(cb)
  local branch_name_job = job:new({
    command = 'git',
    args = { 'remote', 'get-url', 'origin' },
    on_stdout = vim.schedule_wrap(function(err, output)
      if err == nil and output ~= nil then
        cb(output)
      end
    end)
  })

  branch_name_job:start()
end

M.is_gitlab_project = function(cb)
  M.is_inside_work_tree(function()
    M.get_remote_url(function(url)
      if string.find(url, "@gitlab") ~= nil then
        cb() -- If we are inside a git worktree, not on main/master, and in a Gitlab project...
      end
    end)
  end)
end


return M
