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

-- Diffing and Conflicts
local last_tabpage = vim.api.nvim_get_current_tabpage()

function M.DiffviewToggle()
    local lib = require'diffview.lib'
    local view = lib.get_current_diffview()
    if view then
        -- Current tabpage is a Diffview: go to previous tabpage
        vim.api.nvim_set_current_tabpage(last_tabpage)
    else
        -- We are not in a Diffview: save current tabpagenr and go to a Diffview.
        last_tabpage = vim.api.nvim_get_current_tabpage()
        if #lib.views > 0 then
            -- An open Diffview exists: go to that one.
            vim.api.nvim_set_current_tabpage(lib.views[1].tabpage)
        else
            -- No open Diffview exists: Open a new one
            vim.cmd(":DiffviewOpen")
        end
    end
end

-- Full Diffview (plugin)
remap {'n', '<leader>gd', ':DiffviewFileHistory<CR>'}
remap {'n', '<leader>gD', ":lua require('_git').DiffviewToggle()<CR>"}

return M
