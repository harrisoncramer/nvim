local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }

vim.cmd([[
  " Open diff of current file in new tab
  function! GStatusGetFilenameUnderCursor()
      return matchstr(getline('.'), '^[A-Z?] \zs.*')
  endfunction

  command! GdiffsplitTab call GdiffsplitTab(expand("%"))
  function! GdiffsplitTab(filename)
      exe 'tabedit ' . a:filename
      Gdiffsplit
  endfunction
]])

vim.keymap.set("n", "df", ":call GdiffsplitTab(GStatusGetFilenameUnderCursor())<cr>", map_opts)
vim.keymap.set("n", "cc", ":silent! Git commit --quiet<CR>", map_opts)
vim.keymap.set("n", "ca", ":silent! Git commit --amend --quiet<CR>", map_opts)
vim.keymap.set("n", "gr", ":silent! Git reset --soft HEAD~1<CR>", map_opts)
