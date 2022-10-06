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

  " custom mapping in fugitive window (:Git)
  augroup custom_fugitive_mappings
      au!
      au User FugitiveIndex nnoremap <buffer> <leader>df :call GdiffsplitTab(GStatusGetFilenameUnderCursor())<cr>
      au User FugitiveIndex nnoremap <buffer> <C-n> :lua require("plugins.fugitive").jump_next()<CR>
      au User FugitiveIndex nnoremap <buffer> <C-p> :lua require("plugins.fugitive").jump_prev()<CR>
      au User FugitiveIndex nnoremap <buffer> sj <C-w>j
  augroup END
]])

vim.keymap.set("n", "df", ":call GdiffsplitTab(GStatusGetFilenameUnderCursor())<cr>", map_opts)
vim.keymap.set("n", "cc", ":silent! Git commit --quiet<CR>", map_opts)
vim.keymap.set("n", "ca", ":silent! Git commit --amend --quiet<CR>", map_opts)
vim.keymap.set("n", "<C-n>", require("plugins.fugitive").jump_next, map_opts)
vim.keymap.set("n", "<C-p>", require("plugins.fugitive").jump_prev, map_opts)
vim.keymap.set("n", "gr", ":silent! Git reset --soft HEAD~1<CR>", map_opts)
