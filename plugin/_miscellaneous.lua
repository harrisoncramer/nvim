-- BufOnly
nnoremap(':BO', ':BufOnly<CR>')

-- Lightline
vim.cmd[[ let g:lightline = { 'active': { 'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ] ], 'right': [ [ 'lineinfo' ], [ 'percent' ], [ ] ] }, 'component_function': { 'gitbranch': 'gitbranch#name' }, } ]]
vim.cmd[[

  " Hide lightline
  :setlocal statusline=%#Normal#

]]

-- Vim closetag
vim.g.closetag_filenames = "*.html,*.jsx,*.js,*.tsx"

-- Vim Wiki (turn off mappings)
vim.g.vimwiki_map_prefix = '<Leader><F13>'

-- Git Gutter use GitGutter on save (disable by default at startup)
-- nnoremap('<leader>gg', ':GitGutterToggle<CR>')

-- Emmet
vim.g.user_emmet_leader_key = '<C-e>'
