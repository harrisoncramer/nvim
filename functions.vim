""""""""""""""""""
" FUNCTIONS
"""""""""""""""""" 

" Remap <leader>q to open quickfix list
function! PrintQList() 
for winnr in range(1, winnr('$'))
    :if getwinvar(winnr, '&syntax') == 'qf'
      :cclose
    :else
      :copen
    :endif
endfor
endfunction
nnoremap <silent> <leader>q :call PrintQList()<cr>
" Removes comments (of type // and #)
command! NoCom execute NoComment()
function! NoComment()
  :silent :%! grep -v '^\/\/'
  :silent :%! grep -v '\/\/\ '
  :silent :%! grep -ve '^\#\ '
endfunction
" Removes blank lines
command! NoBlank execute NoBlank()
function! NoBlank()
  :silent :%! grep -ve '^[[:space:]]*$'
endfunction
" Create new file and folders within current working director with :E
function s:MKDir(...)
    if         !a:0 
           \|| stridx('`+', a:1[0])!=-1
           \|| a:1=~#'\v\\@<![ *?[%#]'
           \|| isdirectory(a:1)
           \|| filereadable(a:1)
           \|| isdirectory(fnamemodify(a:1, ':p:h'))
        return
    endif
    return mkdir(fnamemodify(a:1, ':p:h'), 'p')
endfunction
command! -bang -bar -nargs=? -complete=file E :call s:MKDir(<f-args>) | e<bang> <args>

