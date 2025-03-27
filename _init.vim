" These are some useful Vimscript snippets that I've collected over time.
" I'm not great at Vimscript, so I'm sure there are better ways to do some of
" these things. I'm consolidating them here for easy reference.


" This function allows you to select text in visual mode and then press `*` to initiate a search for 
" that exact text, similar to how `*` works in normal mode for the word under the cursor. 
" It's a useful feature for quickly finding other instances of the selected text within the document.
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
  let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>

" These mappings allow you to jump multiple lines up or down
" and enable the use of a temporary mark `m'` to return to the starting point with the backtick `'` mark command.
" This is useful for quickly returning to your previous position with <C-o> or <C-i>
nnoremap <expr> k (v:count > 1 ? "m'" . v:count . 'k' : 'k')
nnoremap <expr> j (v:count > 1 ? "m'" . v:count . 'j' : 'j')
