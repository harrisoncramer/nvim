""""""""""""""""""
" PLUGIN CONFIG
"""""""""""""""""" 
" FZF
" Populate the quickfix with results
nnoremap <c-q> :FindAndPopulateQuickfix<cr>

" Access FZF quickly
nnoremap <c-f> :Find<cr>
" Access FZF quickly (filenames only). See https://github.com/junegunn/fzf.vim for more commands
nnoremap <c-j> :Files<cr>

" Access Buffer list
nnoremap <c-b> :Buffer<cr>

" Remap grep to use silent search and populate quickfix list
command! -nargs=+ VG
\   execute 'silent vimgrep <args>'

" CONFIGURE FIND SEARCH FOR FILES
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git,yarn.lock,etc.)
" --color: Search color options
" --delimiter : --nth 4... Ensures that we only search content, not filename

" This is the equivalent of calling :FZF vimgrep rg ....
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow -g "!{yarn.lock,package-lock.json,public,node_modules,.git,yarn-error.log,yarn.lock,dist,build}" --color "always" '.shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" Vim Fugitive (GIT)
function! ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
command! ToggleGStatus :silent :call ToggleGStatus()
nnoremap <silent> <leader>gs :ToggleGStatus<CR>
function! ToggleGLog()
    if buflisted(bufname('fugitive'))
      :cclose
      :execute "normal! :bdelete fugitive*\<C-a>\<CR>"
    else
        Glog
    endif
endfunction
command! ToggleGLog :silent :call ToggleGLog()
nnoremap <silent> <leader>gl :ToggleGLog<CR>
function! ToggleGDiff()
    if buflisted(bufname('fugitive'))
      :execute "normal! :bdelete fugitive*\<C-a>\<CR>"
    else
        Gdiff
    endif
endfunction
command! ToggleGDiff :silent :call ToggleGDiff()
nnoremap <silent> <leader>gd :ToggleGDiff<CR>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gp :Git push<cr>
nnoremap <leader>gh :0Glog<cr>
nnoremap <leader>gb :Gbrowse<cr>
" Open git in browser
nnoremap <leader>go :G open<cr>
" Three way split for a merge (on a conflicted file)
nnoremap <silent> <leader>gm :Gvdiffsplit!<cr>
nnoremap <silent> <leader>gf :diffget //2<cr>
nnoremap <silent> <leader>gh :diffget //3<cr>

" CircleCI (CLI)
nnoremap <silent> <leader>co :! circleci --skip-update-check open<cr>

" Vim Snippets
let g:UltiSnipsSnippetDirectories=["UltiSnips", "/Users/harrisoncramer/.config/nvim/my_snippets"]
let g:UltiSnipsExpandTrigger = "<C-o>" " Expands the snippet that aren't automatically expanded
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-l>'
" Turn on Ultisnips in Javascript file for javascriptreact files
autocmd FileType javascriptreact UltiSnipsAddFiletypes javascript


" Conquer of Completion (CoC)
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-stylelintplus',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-eslint',
  \ 'coc-emmet',
  \ 'coc-sql',
  \ 'coc-go',
  \ 'coc-css'
  \ ]
" use <c-k> to see autocompletion list
inoremap <silent><expr> <C-k> coc#refresh()
" Use tab and shift tab to navigate completion menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Use <cr> to confirm completion
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" When prettier is called, format the file
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" Manage errors/warnings
nmap <silent> <leader>e <Plug>(coc-diagnostic-next-error)
nmap <silent> <leader>b <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>w <Plug>(coc-diagnostic-next)
" Show documentation for variable (don't worry about vim breaking)
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction
" Rename 
nmap <silent> R <Plug>(coc-rename)
" Go to definition of variable.
map <silent> gd <Plug>(coc-definition)
" Open definition in a new split 
map gs :only<bar>vsplit<CR>gd
" Go to type of variable
nmap <silent> gt <Plug>(coc-type-definition)
" Go to implementation
nmap <silent> gi <Plug>(coc-implementation)
" Scroll through references within the same file
map <silent> gr <Plug>(coc-references)

" Explorer
nnoremap <silent> :: :CocCommand explorer<CR>
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

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
