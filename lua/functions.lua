-- Remap <leader>q to open quickfix list
vim.cmd[[
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
]]
