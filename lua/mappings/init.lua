local remap = require("functions").remap

-- File specific mappings
require("mappings.vue")
require("mappings.work")
require("mappings.git")

-- Splits
remap({ "n", "ss", ":split<Return><C-w>w" })
remap({ "n", "sv", ":vsplit<Return><C-w>w" })
remap({ "n", "sh", "<C-w>h" })
remap({ "n", "sj", "<C-w>j" })
remap({ "n", "sk", "<C-w>k" })
remap({ "n", "sl", "<C-w>l" })
remap({ "n", "sq", "<C-w>q" })
remap({ "n", "sp", "<C-w><C-p>" })

-- Buffers
remap({ "n", "<leader>-", ":bd<CR>" })
remap({ "n", "<C-n>", ":bnext<CR>" })
remap({ "n", "<C-p>", ":bprev<CR>" })
remap({ "n", "<C-t>", "<C-^>" })
remap({ "n", "<C-x>", ":bp <bar> bd#<CR>" })

require("compat").remap(
	"n",
	"R",
	require("functions").start_replace,
	{},
	":lua require('functions').start_replace()<CR>"
)

-- Luafile
remap({ "n", "<leader>lf", ":luafile %<CR>" })
vim.cmd([[command! -nargs=1 RL lua require("functions").reload(<f-args>)]])
vim.cmd([[command! RLC lua require("functions").reload_current()]])

-- LSP
require("compat").remap("n", "<leader>F", vim.lsp.buf.formatting, {}, ":lua vim.lsp.buf.formatting()<CR>")

-- Neovim
remap({ "n", "<leader>vv", ":e $MYVIMRC<cr>" })

-- Miscellaneous
remap({ "n", "<C-a>", "<esc>ggVG<CR>" }) -- Select all
remap({ "n", "*", ":keepjumps normal! mi*`i<CR>" }) -- " Use * to add w/out jumping
remap({ "v", "<Leader>y", '"+y' }) -- Copy to clipboard
remap({ "n", "<Leader>p", '"*p' }) -- Paste from system clipboard
remap({ "n", "H", ":w<CR>" }) -- Quick save
remap({ "n", "Y", "y$" }) -- Copy until end of line
remap({ "i", "<C-l>", "<Right>" }) -- Move right in insert
remap({ "n", "<leader>lf", ":luafile %<cr>" })

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
