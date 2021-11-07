" BufOnly
nnoremap :BO :BufOnly<CR>

" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" Golang
let g:go_info_mode='gopls'
command! -nargs=+ GoDocs
\   execute 'grep "<args>" /usr/local/go/src/**/*.go -s'
\ | redraw!

" Vim closetag
let g:closetag_filenames = "*.html,*.jsx,*.js,*.tsx"


" Vim Wiki (turn off mappings)
let g:vimwiki_map_prefix = '<Leader><F13>'


" Git Gutter use GitGutter on save
autocmd BufWritePost * GitGutter

" Vim Toggle Terminal
nnoremap <silent> <C-z> :ToggleTerminal<Enter>
tnoremap <silent> <C-z> <C-\><C-n>:ToggleTerminal<Enter>

" Vim VUE
let g:vue_pre_processors = []

" Treesitter
lua <<EOF
require('nvim-treesitter.configs').setup({
  ignore_install = { "haskell" },
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true
  }
})
EOF
