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

local function open_url(url)
  vim.cmd('exec "!xdg-open \'' .. url .. '\'"')
end

local function get_branch_name()
    for line in io.popen("git branch 2>nul"):lines() do
        local m = line:match("%* (.+)$")
        if m then return m end
    end

    return false
end

function Shortcut()
    local branch = get_branch_name()
    local finalUrl = "https://app.shortcut.com/crossbeam/story"
    branch = get_branch_name() .. "/"

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
    open_url(finalUrl)
end

function Calendar()
  open_url("https://calendar.google.com/")
end

vim.cmd [[ command! SC lua Shortcut() ]]
vim.cmd [[ command! CAL lua Calendar() ]]
