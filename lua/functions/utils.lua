local List = require("functions.list")

-- These are functions that are used within the Lua
-- configuration and are not meant for export to the end
-- user.


-- Validates number + function for debounce, see https://gist.github.com/runiq/31aa5c4bf00f8e0843cd267880117201
local function td_validate(fn, ms)
  vim.validate({
    fn = { fn, "f" },
    ms = {
      ms,
      function(ms)
        return type(ms) == "number" and ms > 0
      end,
      "number > 0",
    },
  })
end

local function string_starts(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

local function press_enter()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", false, true, true), "n", false)
end

local function get_line_number()
  return vim.api.nvim_win_get_cursor(0)[1]
end


local merge = function(...)
  local res = {}
  for _, t in ipairs({ ... }) do
    for _, value in ipairs(t) do
      table.insert(res, value)
    end
  end
  return res
end

local basename = function(str)
  local name = string.gsub(str, "(.*/)(.*)", "%2")
  return name
end

---Splits a string by new lines and returns an iterator
---@param s string The string to split
---@return table: An iterator object
local split_by_new_lines = function(s)
  if s:sub(-1) ~= "\n" then
    s = s .. "\n"
  end                       -- Append a new line to the string, if there's none, otherwise the last line would be lost.
  return s:gmatch("(.-)\n") -- Match 0 or more (as few as possible) characters followed by a new line.
end

local list_files_in_folder = function(folder_path)
  if vim.fn.isdirectory(folder_path) == 0 then
    return nil
  end

  local folder_ok, folder = pcall(vim.fn.readdir, folder_path)

  if not folder_ok then
    return nil
  end

  local files = {}
  if folder ~= nil then
    files = List.new(folder)
        :map(function(file)
          local file_path = folder_path .. "/" .. file
          local timestamp = vim.fn.getftime(file_path)
          return { name = file, timestamp = timestamp }
        end)
        :sort(function(a, b)
          return a.timestamp > b.timestamp
        end)
        :map(function(file)
          return file.name
        end)
  end
  return files
end

---Takes a string of lines and returns a table of lines
---@param s string The string to parse
---@return table
local lines_into_table = function(s)
  local lines = {}
  for line in split_by_new_lines(s) do
    table.insert(lines, line)
  end
  return lines
end

local read_file = function(file_path, opts)
  local file = io.open(file_path, "r")
  if file == nil then
    return nil
  end
  local file_contents = file:read("*all")
  file:close()

  if opts and opts.remove_newlines then
    file_contents = string.gsub(file_contents, "\n", "")
  end

  return file_contents
end

local copy_file_name = function(quiet)
  local buf_name = vim.api.nvim_buf_get_name(0)
  local base = basename(buf_name)
  vim.fn.setreg("+", base)
  if not quiet then
    require("notify")('Copied file name.', vim.log.levels.INFO)
  end
  return base
end

local get_os = function()
  return vim.loop.os_uname().sysname
end

return {
  get_os = get_os,
  get_home = function()
    return os.getenv("HOME")
  end,
  get_date_time = function()
    local date_table = os.date("*t")
    local hour, minute = date_table.hour, date_table.min
    local year, month, day = date_table.year, date_table.month, date_table.day -- date_table.wday to date_table.day
    local result = string.format("%02d-%02d-%04d__%d:%d", month, day, year, hour, minute)
    return result
  end,
  jump_to_line = function(search_text)
    if search_text == nil then return end
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
      if string.find(line, search_text, 1, true) then
        vim.fn.cursor({ i, 1 })
        return true
      end
    end
    return false
  end,
  get_buffer_name = function()
    return vim.fn.expand("%")
  end,
  current_dir = function()
    return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end,
  get_buffer_text = function(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local text = table.concat(lines, "\n")
    return text
  end,
  get_line_number = get_line_number,
  get_line_content = function()
    return vim.api.nvim_buf_get_lines(0, get_line_number() - 1, get_line_number(), false)[1]
  end,
  make_words_from_string = function(s)
    local words = {}
    for word in s:gmatch("%w+") do table.insert(words, word) end
    return words
  end,
  open_url = function(url)
    local opener = get_os() == "Linux" and "xdg-open" or "open"
    vim.cmd("exec \"!" .. opener .. " '" .. url .. "'\"")
  end,
  file_exists = function(name)
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
  end,
  escape_string = function(text)
    return text:gsub("([^%w])", "%%%1")
  end,
  debounce = function(fn, ms, first)
    td_validate(fn, ms)
    local timer = vim.loop.new_timer()
    local wrapped_fn

    if not first then
      function wrapped_fn(...)
        local argv = { ... }
        local argc = select("#", ...)

        timer:start(ms, 0, function()
          pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
        end)
      end
    else
      local argv, argc
      function wrapped_fn(...)
        argv = argv or { ... }
        argc = argc or select("#", ...)

        timer:start(ms, 0, function()
          pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
        end)
      end
    end
    return wrapped_fn, timer
  end,
  strip_extension = function(filename)
    local pattern = "(.+)%.%w+$"
    for name in filename:gmatch(pattern) do
      return name
    end
    return nil
  end,
  remove_file = function(filename)
    local cwd = vim.fn.getcwd()
    local filepath = cwd .. '/' .. filename
    local plenary_ok, job = pcall(require, "plenary.job")
    if not plenary_ok then
      require("notify")("Could not load Plenary.", vim.log.levels.ERROR)
      return
    end
    job:new({
      command = 'rm',
      args = { filepath },
      on_exit = vim.schedule_wrap(function(_, exit_code)
        if exit_code ~= 0 then
          require("notify")(filename .. " failed to remove", vim.log.levels.ERROR)
          return
        else
          require("notify")(filename .. " removed successfully.", vim.log.levels.INFO)
        end
      end),
    }):start()
  end,
  press_enter = press_enter,
  basename = basename,
  dirname = function(str)
    local name = string.gsub(str, "(.*/)(.*)", "%1")
    return name
  end,
  trim_file_path = function(full_path, dir)
    local dir_pattern = "^" .. dir:gsub("/", "%%/") .. "/"
    local trimmedPath = full_path:gsub(dir_pattern, "")
    return trimmedPath
  end,
  string_starts = string_starts,
  copy_absolute_dir = function(quiet)
    local dir_path = vim.fn.expand('%:p:h') .. '/'
    vim.fn.setreg("+", dir_path)
    if not quiet then
      require("notify")('Copied absolute directory.', vim.log.levels.INFO)
    end
    return dir_path
  end,
  copy_relative_dir = function(quiet)
    local dir_path = vim.fn.fnamemodify(vim.fn.expand('%:h'), ':p:~:.')
    vim.fn.setreg("+", dir_path)
    if not quiet then
      require("notify")('Copied relative directory.', vim.log.levels.INFO)
    end
    return dir_path
  end,
  copy_file_name = copy_file_name,
  copy_relative_filepath = function(quiet)
    local file_path = vim.fn.fnamemodify(vim.fn.expand('%:h'), ':p:~:.')
    local file_name = copy_file_name(true)
    local res = file_path .. file_name
    vim.fn.setreg("+", res)
    if not quiet then
      require("notify")('Copied relative filepath.', vim.log.levels.INFO)
    end

    return res
  end,
  return_bare_file_name = function()
    local full_file_name = vim.fn.expand('%:t')
    local file_name = ''
    for part in string.gmatch(full_file_name, "[^.]+") do
      file_name = part
      break
    end
    return file_name
  end,
  get_buf_by_name = function(name, starts_with)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if starts_with then
        if string_starts(buf_name, name) then
          return buf
        end
      end
      local base_name = basename(buf_name)
      if base_name == name then
        return buf
      end
    end
    return -1
  end,
  get_win_by_buf_name = function(name)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local base_name = basename(buf_name)
      if base_name == name then
        return win
      end
    end
    return -1
  end,
  get_tab_by_buf_name = function(name, starts_with)
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      local win = vim.api.nvim_tabpage_get_win(tab)
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if starts_with then
        if string_starts(buf_name, name) then
          return tab
        end
      else
        local base_name = basename(buf_name)
        if base_name == name then
          return tab
        end
      end
    end
    return -1
  end,
  split = function(str, delimiter)
    local result = {}
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
      table.insert(result, match)
    end
    return result
  end,
  replace_text_with_file = function(folder)
    local all_templates = list_files_in_folder(folder)
    if all_templates == nil then
      return
    end
    vim.ui.select(all_templates, {
      prompt = "Choose Test Template",
    }, function(choice)
      if choice == nil then
        return
      end
      local lines = read_file("test_templates" .. "/" .. choice)
      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines_into_table(lines))
    end)
  end,
  resize_vertical_splits = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
  end,
  get_current_buf_name = function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local base_name = basename(buf_name)
    return base_name
  end,
  get_word_under_cursor = function()
    return vim.fn.expand("<cword>")
  end,
  blank_line_below = function()
    vim.fn.append(vim.fn.line("."), "")
  end,
  blank_line_above = function()
    vim.fn.append(vim.fn.line(".") - 1, "")
  end,
  move_line_down = function()
    vim.api.nvim_feedkeys("ddp", "n", false)
  end,
  move_line_up = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("dd<Up>P", false, true, true), "n", false)
  end,
  merge = merge,
  has_value = function(table, val)
    for _, value in ipairs(table) do
      if value == val then
        return true
      end
    end
    return false
  end,
  close_floating_windows = function()
    for _, win in pairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative == 'win' then
        vim.api.nvim_win_close(win, false)
      end
    end
  end,
  ---Checks if an executable is installed
  ---@param executable string
  ---@return boolean
  has_executable = function(executable)
    local result = vim.fn.executable(executable)
    return result == 1
  end
}
