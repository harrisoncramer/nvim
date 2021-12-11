local remap = _G.remap

-- BufOnly
remap{'n', ':BO', ':BufOnly<CR>' }

-- Vim closetag
vim.g.closetag_filenames = "*.html,*.jsx,*.js,*.tsx,*.vue"

-- Vim Wiki (turn off mappings)
vim.g.vimwiki_map_prefix = '<Leader><F13>'

-- Emmet
vim.g.user_emmet_leader_key = '<C-e>'
