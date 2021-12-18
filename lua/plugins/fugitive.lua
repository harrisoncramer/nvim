local M = {}
M.setup = function(remap)
    remap {'n', '<leader>gs', ':lua require("plugins.fugitive").ToggleGStatus()<CR>'}
    remap {'n', '<leader>gl', ':lua require("plugins.fugitive").ToggleGLog()<CR>'}
    remap {'n', '<leader>gP', ':Git push<cr>'}
    remap {'n', '<leader>go', ':!git open<cr><cr>'}
end

M.ToggleGStatus = function()
  vim.cmd [[
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Git
    endif
  ]]
end

M.ToggleGLog = function()
  vim.cmd [[
    if buflisted(bufname('fugitive'))
      :cclose
      :execute "normal! :bdelete fugitive*\<C-a>\<CR>"
    else
      Gclog
    endif
  ]]
end

return M
