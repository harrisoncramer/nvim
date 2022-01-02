local remap = require("functions").remap

-- MAPPINGS
-- Creating and moving around splits
remap({ "n", "ss", ":split<Return><C-w>w" })
remap({ "n", "sv", ":vsplit<Return><C-w>w" })
remap({ "n", "sh", "<C-w>h" })
remap({ "n", "sj", "<C-w>j" })
remap({ "n", "sk", "<C-w>k" })
remap({ "n", "sl", "<C-w>l" })
remap({ "n", "sq", "<C-w>q" })
remap({ "n", "sp", "<C-w><C-p>" })

-- Buffer management
remap({ "n", "<leader>-", ":bd<CR>" })
remap({ "n", "<C-n>", ":bnext<CR>" })
remap({ "n", "<C-p>", ":bprev<CR>" })
remap({ "n", "<C-t>", "<C-^>" })
remap({ "n", "<C-x>", ":bp <bar> bd#<CR>" })

-- Tabs
vim.cmd([[ :ca tc tabclose<CR> ]])
vim.cmd([[ :ca tn tabnew<CR> ]])

-- Lua
remap({ "n", "<leader>lf", ":luafile %<CR>" })

-- LSP
remap({ "n", "<leader>F", ":lua vim.lsp.buf.formatting()<CR>" })

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

-- Jump to end of visual copy
vim.cmd([[ vnoremap <expr>y "my\"" . v:register . "y`y" ]])

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

vim.cmd([[
  " Visual mode search with * for selected text
  function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    " Use this line instead of the above to match matches spanning across lines
    "let @/ = '\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
    call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
    let @@ = temp
  endfunction
  vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
]])

vim.cmd([[command! SC lua require("functions").shortcut() ]])
vim.cmd([[command! CAL lua require("functions").calendar() ]])
