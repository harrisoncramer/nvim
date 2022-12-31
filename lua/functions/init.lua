local u = require("functions.utils")

-- Globals
function _G.P(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, "\n"))
  return ...
end

-- These are functions that could theoretically be called by the user
-- although they are generally used by other commands (in the commands.lua file)
-- or are used by mappings (in the mappings directory)

return {
  capture = function(cmd, raw)
    local f = assert(io.popen(cmd, "r"))
    local s = assert(f:read("*a"))
    f:close()
    if raw then
      return s
    end
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
    s = string.gsub(s, "[\n\r]+", " ")
    return s
  end,
  start_replace = function()
    vim.cmd.startreplace()
  end,
  reload = function(package_name)
    local t = u.split(package_name, " ")
    for _, value in ipairs(t) do
      package.loaded[value] = nil
      local status = pcall(require, value)
      if not status then
        require("notify")(value .. " is not available.", "warn")
      end
    end
  end,
  reload_current = function()
    local current_buffer = u.get_buffer_name()
    local module_name = u.split(current_buffer, "/lua")
    local patterns = { "/", ".lua" }
    for _, value in ipairs(patterns) do
      module_name = string.gsub(current_buffer, value, "")
    end
    package.loaded[module_name] = nil
    local status = pcall(require, module_name)
    if not status then
      require("notify")(module_name .. " is not available.", "error")
    end
  end,
  shortcut = function()
    local branch = u.get_branch_name()
    local finalUrl = "https://app.shortcut.com/crossbeam/story"
    branch = u.get_branch_name() .. "/"

    if not string.find(branch, "sc%-") then
      require("notify")("Not a shortcut branch", "error")
      return
    end

    local parts = {}
    for word in string.gmatch(branch, "(.-)/") do
      table.insert(parts, word)
    end
    for i = #parts, 1, -1 do
      finalUrl = finalUrl .. "/" .. parts[i]
    end
    finalUrl = finalUrl:gsub("(sc%-)", "")
    u.open_url(finalUrl)
  end,
  calendar = function()
    u.open_url("https://calendar.google.com/")
  end,
  create_or_source_obsession = function()
    local async_job_ok, job = pcall(require, 'plenary.job')
    local is_git = u.file_exists(".git")
    if not is_git then
      return
    end

    local has_obsession = vim.fn.exists(":Obsession")
    if has_obsession == 0 then
      require("notify")("Obsesssion is not installed", "warn")
      return
    end

    if not async_job_ok then
      require("notify")("Plenary is not yet installed", "warn")
      return
    end

    local args = vim.v.argv
    if #args ~= 1 then
      return nil
    end
    local branch = u.get_branch_name()
    if not branch then
      branch = "init_branch_session"
    else
      branch = branch:gsub("%W", "")
    end
    if vim.fn.isdirectory(".sessions") == 1 then
      -- TODO: Check for sessions directory at root
      local session_path = ".sessions/session." .. branch .. ".vim"
      if u.file_exists(session_path) then
        vim.cmd(string.format("silent source %s", session_path))
        vim.cmd(string.format("silent Obsession %s", session_path))
      else
        vim.cmd(string.format("silent Obsession %s", session_path))
      end
    else
      require("notify")("Creating sessions directory...", "warn")
      job:new({
        command = "mkdir",
        args = { vim.fn.getcwd() .. "/" .. ".sessions" },
        on_exit = function(_, exit_code)
          if exit_code ~= 0 then
            require("notify")("Could not make sessions directory", "error")
          end
        end,
      }):start()
    end
  end,
  run_script = function(script_name, args)
    local nvim_scripts_dir = "~/.config/nvim/scripts"
    local f = nil
    if args == nil then
      f = io.popen(string.format("/bin/bash %1s/%2s", nvim_scripts_dir, script_name))
    else
      f = io.popen(string.format("/bin/bash %1s/%2s %3s", nvim_scripts_dir, script_name, args))
    end
    local output = f:read("*a")
    f:close()
    return output
  end,
  stash = function(name)
    vim.fn.system("git stash -u -m " .. name)
  end,
  buf_only = function()
    local option = vim.api.nvim_buf_get_option
    local del_non_modifiable = vim.g.bufonly_delete_non_modifiable or false

    local cur = vim.api.nvim_get_current_buf()

    local deleted, modified = 0, 0

    for _, n in ipairs(vim.api.nvim_list_bufs()) do
      -- If the iter buffer is modified one, then don't do anything
      if option(n, "modified") then
        -- iter is not equal to current buffer
        -- iter is modifiable or del_non_modifiable == true
        -- `modifiable` check is needed as it will prevent closing file tree ie. NERD_tree
        modified = modified + 1
      elseif n ~= cur and (option(n, "modifiable") or del_non_modifiable) then
        vim.api.nvim_buf_delete(n, {})
        deleted = deleted + 1
      end
    end

    require("notify")("BufOnly: " .. deleted .. " deleted buffer(s), " .. modified .. " modified buffer(s)")
  end,
  screenshot = function()
    local async_job_ok, job = pcall(require, 'plenary.job')
    if not async_job_ok then
      require("notify")("Plenary is not installed!", "error")
    end

    local language = vim.bo.filetype
    local line_number = vim.api.nvim_win_get_cursor(0)[1]
    local create_screenshot = job:new({
      command = 'silicon',
      args = { '--from-clipboard', '-l', language, '--to-clipboard', '--line-offset', line_number },
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          require("notify")("Could not create screenshot! Do you have silicon installed?", "error")
          return
        end
        require("notify")("Screenshot copied to clipboard", vim.log.levels.INFO)
      end,
    })

    create_screenshot:start()
  end
}
