require("toggleterm").setup{
  open_mapping = [[<c-z>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = false,
  -- shading_factor = 3, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  close_on_exit = false
}

function _G.set_terminal_keymaps()
  tnoremap('<esc>', '<C-\\><C-n>')
end

vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

vim.cmd[[
" By applying the mappings this way you can pass a count to your
" mapping to open a specific window. For example: 2<C-t> will open terminal 2
nnoremap <silent><c-z> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-z> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
]]

