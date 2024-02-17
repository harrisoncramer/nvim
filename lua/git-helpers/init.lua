local u = require("functions.utils")
local job = require('plenary.job')
local M = {}

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


-- M.add_current_file = function()
--   local file = u.copy_relative_filepath(true)
--   job:new({
--     command = 'git',
--     args = { 'add', file },
--     on_exit = vim.schedule_wrap(function(_, exit_code)
--       if exit_code ~= 0 then
--         require("notify")('Could not add file!', "error")
--         return
--       else
--         M.commit_file()
--       end
--     end),
--   }):start()
-- end

M.commit_file = function()
  local relative_file_path = u.copy_relative_filepath(true)
  job:new({
    command = 'git',
    args = { "commit", relative_file_path, "-m", string.format("Refactor to %s", relative_file_path) },
    on_exit = vim.schedule_wrap(function(data, exit_code)
      if exit_code ~= 0 then
        print(exit_code)
        vim.print(data)
        require("notify")('Could not commit change!', "error")
        return
      else
        M.commit_file()
      end
    end),
  }):start()
end

return M
