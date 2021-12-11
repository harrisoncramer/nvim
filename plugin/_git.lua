-- Main fugitive commands.
local remap = _G.remap
local M = {}

remap {'n', '<leader>gs', ':ToggleGStatus<CR>'}
remap {'n', '<leader>gl', ':ToggleGLog<CR>'}
remap {'n', '<leader>gP', ':Git push<cr>'}
remap {'n', '<leader>go', ':G open<cr>'}

-- Gitsigns w/ hunks and blames.
remap {'n', '<leader>ga', ':Gitsigns stage_hunk<CR>'}
remap {'n', '<leader>gb', ':Gitsigns blame_line<CR>'}
remap {'n', '<leader>gp', ':Gitsigns prev_hunk<CR>'}
remap {'n', '<leader>gn', ':Gitsigns next_hunk<CR>'}

function _G.ToggleGStatus()
    vim.cmd [[
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Git
    endif
  ]]
end

vim.cmd [[ command! ToggleGStatus lua ToggleGStatus() ]]

function _G.ToggleGLog()
    vim.cmd [[
    if buflisted(bufname('fugitive'))
      :cclose
      :execute "normal! :bdelete fugitive*\<C-a>\<CR>"
    else
      Gclog
    endif
  ]]
end

vim.cmd [[ command! ToggleGLog lua ToggleGLog() ]]

