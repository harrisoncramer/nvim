-- BufOnly
nnoremap(':BO', ':BufOnly<CR>')

-- Lightline
vim.cmd[[ let g:lightline = { 'active': { 'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ] ], 'right': [ [ 'lineinfo' ], [ 'percent' ], [ ] ] }, 'component_function': { 'gitbranch': 'gitbranch#name' }, } ]]
vim.cmd[[

  " Hide lightline
  :setlocal statusline=%#Normal#

]]

-- Vim closetag
vim.g['closetag_filenames'] = "*.html,*.jsx,*.js,*.tsx"

-- Vim Wiki (turn off mappings)
vim.g['vimwiki_map_prefix'] = '<Leader><F13>'

-- Git Gutter use GitGutter on save
vim.cmd[[ autocmd BufWritePost * GitGutter ]]

-- Startify
vim.cmd[[
    let g:startify_custom_header = 'startify#center(startify#fortune#cowsay())'
    let g:startify_bookmarks = [{ 'v': '~/.config/nvim/init.lua'}, {'z': '~/.oh-my-zsh/custom/.zshrc' }]
  
]]

vim.cmd[[
  let g:startify_custom_header = [
            \ '                                ',
            \ '            __                  ',
            \ '    __  __ /\_\    ___ ___      ',
            \ '   /\ \/\ \\/\ \ /'' __` __`\   ',
            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \   ',
            \ '    \ \___/  \ \_\ \_\ \_\ \_\  ',
            \ '     \/__/    \/_/\/_/\/_/\/_/  ',
  \ ]
]]


