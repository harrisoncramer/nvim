-- These are non-language specific autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
  desc = "Highlights the yanked text",
})

-- Taken from: https://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
vim.cmd([[
  function s:MkNonExDir(file, buf)
      if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
          let dir=fnamemodify(a:file, ':h')
          if !isdirectory(dir)
              call mkdir(dir, 'p')
          endif
      endif
  endfunction
  augroup BWCCreateDir
      autocmd!
      autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
  augroup END
]])
