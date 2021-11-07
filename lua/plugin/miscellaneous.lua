-- BufOnly
nnoremap(':BO', ':BufOnly<CR>')

-- Lightline
vim.cmd[[ let g:lightline = { 'active': { 'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ] ], 'right': [ [ 'lineinfo' ], [ 'percent' ], [ ] ] }, 'component_function': { 'gitbranch': 'gitbranch#name' }, } ]]

-- Vim closetag
vim.g['closetag_filenames'] = "*.html,*.jsx,*.js,*.tsx"

-- Vim Wiki (turn off mappings)
vim.g['vimwiki_map_prefix'] = '<Leader><F13>'

-- Git Gutter use GitGutter on save
vim.cmd[[ autocmd BufWritePost * GitGutter ]]

-- Vim Toggle Terminal
nnoremap('<C-z>', ':ToggleTerminal<CR>', 'silent')
tnoremap('<C-z>', '<C-\\><C-n>:ToggleTerminal<Enter>', 'silent')

-- Vim Vue
-- let g:vue_pre_processors = []
