-- Use plugin for easier remapping https://github.com/b0o/mapx.nvim
local remap = _G.remap
local M = {}

-- Creating and moving around splits
remap{'n', 'ss', ':split<Return><C-w>w'}
remap{'n', 'sv', ':vsplit<Return><C-w>w'}
remap{'n', 'sh', '<C-w>h'}
remap{'n', 'sj', '<C-w>j'}
remap{'n', 'sk', '<C-w>k'}
remap{'n', 'sl', '<C-w>l'}
remap{'n', 'sq', '<C-w>q'}
remap{'n', 'sp', '<C-w><C-p>'}

-- Go to definition in a vertical split.
remap{'n', 'gvd', ':vsplit<CR> :lua vim.lsp.buf.definition()<CR>'}

-- Buffer management
remap{'n', '<leader>-', ':bd<CR>'}
remap{'n', '<C-n>', ':bnext<CR>'}
remap{'n', '<C-p>', ':bprev<CR>'}
remap{'n', '<C-t>', '<C-^>'}
remap{'n', '<C-x>', ':bp <bar> bd#<CR>'}

-- LSP
remap{'n', '<leader>F', ":lua vim.lsp.buf.formatting_seq_sync()<CR>"}

-- Neovim
remap{'n', '<leader>vv', ':e $MYVIMRC<cr>'}

-- Miscellaneous
remap{'n', '<C-a>', '<esc>ggVG<CR>'} -- Select all
remap{'n', '*', ':keepjumps normal! mi*`i<CR>'} -- " Use * to add w/out jumping
remap{'v', '<Leader>y', '"+y' } -- Copy to clipboard
remap{'n', '<Leader>p', '"*p' } -- Paste from system clipboard
remap{'n', 'H', ":lua vim.lsp.buf.formatting_seq_sync()<CR>:w<CR>"} -- Quick save (no format)
remap{'n', 'C-l', 'zL'} -- Scroll to right
remap{'n', 'C-h', 'zH'} -- Scroll to left
remap{'n', 'Y', 'y$'} -- Copy until end of line
remap{'i', '<C-l>', '<Right>'} -- Move right in insert

 -- Jump to end of visual copy
vim.cmd [[ vnoremap <expr>y "my\"" . v:register . "y`y" ]]

-- Allows numbered jumps to be saved to the jumplist, for use w/ C-o and C-i
vim.api.nvim_exec(
    "nnoremap <expr> k (v:count > 1 ? \"m'\" . v:count : '') . 'k'", false)
vim.api.nvim_exec(
    "nnoremap <expr> j (v:count > 1 ? \"m'\" . v:count : '') . 'j'", false)
