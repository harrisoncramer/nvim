vim.cmd[[ let g:coc_global_extensions = [ 'coc-tsserver', 'coc-prettier', 'coc-json', 'coc-vetur', 'coc-styled-components', 'coc-eslint', 'coc-python', 'coc-emmet', 'coc-sql', 'coc-go', 'coc-css'] ]]

-- Explorer
nnoremap(';;', ':CocCommand explorer<CR>', 'silent')

-- Rename
nmap('R', '<Plug>(coc-rename)', "silent")

-- Errors/Warnings
nmap('<leader>e', '<Plug>(coc-diagnostic-next-error)', 'silent')
nmap('<leader>b', '<Plug>(coc-diagnostic-prev)', 'silent')
nmap('<leader>w', '<Plug>(coc-diagnostic-next)', 'silent')

-- Navigate with tabs, enter to select
inoremap('<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', "expr")
inoremap('<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', "expr")
vim.cmd[[ inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>" ]]

-- Show documentation
vim.api.nvim_set_keymap(
	'n',
	'K',
	':lua show_documentation()<CR>',
	{ noremap = false, silent = true }
);

function show_documentation()
  local filetype = vim.bo.filetype
  if filetype == "vim" or filetype == "help" then
    vim.api.nvim_command("h " .. vim.fn.expand("<cword>"))
  elseif vim.fn["coc#rpc#ready"]() then
    vim.fn.CocActionAsync("doHover")
  else
    vim.api.nvim_command(
      "!" .. vim.bo.keywordprg .. " " .. vim.fn.expand("<cword>")
    )
  end
end

-- Definitions
map('gd', '<Plug>(coc-definition)', 'silent')
nmap('gt', '<Plug>(coc-type-definition)', 'silent')

-- Prettier
vim.cmd[[ command! -nargs=0 Prettier :CocCommand prettier.formatFile ]]
