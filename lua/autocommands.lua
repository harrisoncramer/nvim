-- These are non-language specific autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
  desc = "Highlights the yanked text",
})

-- Position the (global) quickfix window at the very bottom of the window https://github.com/fatih/vim-go/issues/1757
vim.cmd([[
  autocmd FileType qf if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
]])
