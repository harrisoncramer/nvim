-- File specific mappings
require("mappings.vue")
require("mappings.git")
require("mappings.clojure")
require("mappings.markdown")

local u = require("functions.utils")

-- Splits
vim.keymap.set("n", "ss", ":split<Return><C-w>w")
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w")
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")
vim.keymap.set("n", "sq", "<C-w>q")
vim.keymap.set("n", "sp", "<C-w><C-p>")

-- Buffers
vim.keymap.set("n", "<leader>-", ":bd<CR>")
vim.keymap.set("n", "<C-n>", ":bnext<CR>")
vim.keymap.set("n", "<C-p>", ":bprev<CR>")
vim.keymap.set("n", "<C-t>", "<C-^>")
vim.keymap.set("n", "<C-x>", ":bp <bar> bd#<CR>")

-- Shortcuts
vim.keymap.set("n", "R", require("functions").start_replace, {})
vim.keymap.set("n", "<leader>y", function()
	vim.api.nvim_feedkeys("^vg_y", "n", false)
end)
vim.keymap.set("n", "<C-l>", "20zl")
vim.keymap.set("n", "<C-h>", "40zh")

-- Luafile
vim.keymap.set("n", "<leader>lf", ":luafile %<CR>")

-- LSP
vim.keymap.set("n", "<leader>F", vim.lsp.buf.formatting, {})

-- Neovim
vim.keymap.set("n", "<leader>vv", ":e $MYVIMRC<cr>")

-- Miscellaneous
vim.keymap.set("n", "<C-a>", "<esc>ggVG<CR>") -- Select all
vim.keymap.set("n", "*", ":keepjumps normal! mi*`i<CR>") -- " Use * to add w/out jumping
vim.keymap.set("n", "&", function()
	vim.api.nvim_feedkeys(":keepjumps normal! mi*`i<CR>", "n", false)
	u.press_enter()
	vim.api.nvim_feedkeys(":%s//", "n", false)
end)
vim.keymap.set("v", "<Leader>y", '"+y') -- Copy to clipboard
vim.keymap.set("n", "<Leader>p", '"*p') -- Paste from system clipboard
vim.keymap.set("n", "H", ":w<CR>") -- Quick save
vim.keymap.set("n", "Y", "y$") -- Copy until end of line
vim.keymap.set("i", "<C-l>", "<Right>") -- Move right in insert
vim.keymap.set("n", "<leader>lf", ":luafile %<cr>")

-- Open Links
local opener = u.get_os() == "Linux" and "xdg-open" or "open"
vim.keymap.set("n", "gx", string.format('yiW:! %1s <cWORD><CR> <C-r>" & <CR><CR>', opener))

-- Allows numbered jumps to be saved to the jumplist, for use w/ C-o and C-i
vim.api.nvim_exec("nnoremap <expr> k (v:count > 1 ? \"m'\" . v:count : '') . 'k'", false)
vim.api.nvim_exec("nnoremap <expr> j (v:count > 1 ? \"m'\" . v:count : '') . 'j'", false)

-- Visual mode search with * for selected text
vim.cmd([[
  function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
    let @@ = temp
  endfunction
  vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
]])

return {}
