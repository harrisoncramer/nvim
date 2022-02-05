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

local replace = function()
	vim.cmd("startreplace")
end

vim.keymap.set("n", "R", replace)

-- Tabs
vim.cmd([[ :ca tc tabclose<CR> ]])
vim.cmd([[ :ca tn tabnext<CR> ]])
vim.cmd([[ :ca tp tabprev<CR> ]])

-- Luafile
remap({ "n", "<leader>lf", ":luafile %<CR>" })

-- LSP
vim.keymap.set("n", "<leader>F", vim.lsp.buf.formatting)

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

-- Remap <leader>q to open quickfix list
vim.cmd([[
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
]])

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
