-- Highlight after yank
vim.cmd([[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=300 }
  augroup END
]])

vim.cmd([[
  augroup break_in_markdown
  autocmd FileType markdown,text set wrap linebreak nolist
]])
