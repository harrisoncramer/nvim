vim.cmd [[
  " Convert .ts files to typescript (as well as other types)
  au BufNewFile,BufRead *.cjs setlocal filetype=javascript
  au BufNewFile,BufRead *.mjs setlocal filetype=javascript
  autocmd BufRead,BufNewFile *.json set filetype=jsonc

  au BufRead,BufNewFile *.nginx set ft=nginx
  au BufRead,BufNewFile */etc/nginx/* set ft=nginx
  au BufRead,BufNewFile */usr/local/nginx/conf/* set ft=nginx
  au BufRead,BufNewFile nginx.conf set ft=nginx

  augroup my-glyph-palette
    autocmd! *
    autocmd FileType coc-explorer call glyph_palette#apply()
  augroup END

  " Open quickfix automatically
  augroup autoquickfix
      autocmd!
      autocmd QuickFixCmdPost [^l]* cwindow
      autocmd QuickFixCmdPost    l* lwindow
  augroup END

  " Rescan larger files for correct highlighting
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
  autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

  " Allow line wrapping for .wiki files
  autocmd FileType vimwiki set wrap
]]
