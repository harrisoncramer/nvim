local M = {}

-- Remapping function.
M.remap = function(key)
    local opts = {noremap = true, silent = true}
    for i, v in pairs(key) do if type(i) == 'string' then opts[i] = v end end
    local buffer = opts.buffer
    opts.buffer = nil
    if buffer then
        vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
    else
        vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
    end
end

-- Remap <leader>q to open quickfix list
vim.cmd [[
  function! PrintQList()
  for winnr in range(1, winnr('$'))
      :if getwinvar(winnr, '&syntax') == 'qf'
        :cclose
      :else
        :copen
      :endif
  endfor
  endfunction
  nnoremap <silent> <leader>q :call PrintQList()<cr>
]]

M.open_url = function (url)
  vim.cmd('exec "!xdg-open \'' .. url .. '\'"')
end

M.get_branch_name = function()
    for line in io.popen("git branch 2>nul"):lines() do
        local m = line:match("%* (.+)$")
        if m then return m end
    end

    return false
end

function Shortcut()
    local branch = get_branch_name()
    local finalUrl = "https://app.shortcut.com/crossbeam/story"
    branch = M.get_branch_name() .. "/"

    if not string.find(branch, "sc%-") then
      print("Not a shortcut branch")
      return
    end

    local parts = {}
    for word in string.gmatch(branch, '(.-)/') do table.insert(parts, word) end
    for i = #parts, 1, -1 do
      finalUrl = finalUrl .. "/" .. parts[i]
    end
    finalUrl = finalUrl:gsub("(sc%-)", "")
    M.open_url(finalUrl)
end

function Calendar()
  M.open_url("https://calendar.google.com/")
end

vim.cmd [[ command! SC lua Shortcut() ]]
vim.cmd [[ command! CAL lua Calendar() ]]

return M
