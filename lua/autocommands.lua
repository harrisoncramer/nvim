-- Highlight after yank
vim.cmd([[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
  augroup END
]])

vim.cmd([[
  autocmd FileType markdown,text set wrap linebreak nolist textwidth=80 formatoptions=cqt wrapmargin=0
]])

vim.cmd([[
" Position the (global) quickfix window at the very bottom of the window https://github.com/fatih/vim-go/issues/1757
  autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
]])
