""""""""""""""""""
" NORMAL MODE MAPPINGS
"""""""""""""""""" 
"Map control-a to select all. Inside TMUX, hit it twice.
noremap <C-a> <esc>ggVG<CR> 
" Use the s key for splits instead of substitution
nnoremap ss :split<Return><C-w>w
nnoremap sv :vsplit<Return><C-w>w
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sq <C-w>q
" Resize splits
nnoremap <C-w><left> <C-w><
nnoremap <C-w><right> <C-w>>
nnoremap <C-w><up> <C-w>
nnoremap <C-w><down> <C-w>-
nnoremap sf :MaximizerToggle<CR>
" Use * to add to match w/out jumping to next value
nnoremap * :keepjumps normal! mi*`i<CR>
" Allows numbered jumps to be saved to the jumplist, for use w/ C-o and C-i
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'
" Remove all old swapfiles
nnoremap :rmswap :! rm -rf /Users/harrisoncramer/.local/share/nvim/swap<cr>
" Buffer management (close, save and close, close all others, next/prev)
nnoremap <silent> <leader>- :bd<CR>
nnoremap <silent> <leader>h :w\|bd<CR>
nnoremap <silent> <leader>bo :w <bar> %bd <bar> e# <bar> bd# <CR><CR>
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprev<CR>
" Toggle to previous buffer
nnoremap <silent> <C-t> <C-^>

"Source .vimrc file
nnoremap <leader>sv :source $MYVIMRC<cr>
" Allow copying to global clipboard with <leader>cp (see https://vi.stackexchange.com/questions/84/how-can-i-copy-text-to-the-system-clipboard-from-vim)
noremap <silent> <Leader>y "*y
" Quick save
nnoremap H :w<cr>
" Use capital :E to create file in current directory
nnoremap :E :e %:h/
" Scroll screen to right/left (like C-u and C-d)
nnoremap <C-l> zL
nnoremap <C-h> zH
" Copy until end of line
nnoremap Y y$


nnoremap <F4> :%s/<c-r><c-w>/<c-r><c-w>/gc<c-f>$F/i

""""""""""""""""""
" INSERT MODE MAPPINGS
"""""""""""""""""" 
" Move arrow key one space to right
inoremap <C-l> <Right>

""""""""""""""""""
" VISUAL MODE MAPPINGS
"""""""""""""""""" 
" Allow yank in visual mode downward without moving the cursor
vnoremap <expr>y "my\"" . v:register . "y`y"
