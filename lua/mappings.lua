local u = require("functions.utils")

-- Splits
vim.keymap.set("n", "ss", ":split<Return>")
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w")
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")
vim.keymap.set("n", "sq", "<C-w>q")

-- Using a simple plugin to provide better forward/backward surfing
vim.keymap.set("n", "<C-t>", "<C-^>")

-- Neovim
vim.keymap.set("n", "<leader>vv", ":e $MYVIMRC<cr>")

-- Miscellaneous
vim.keymap.set("n", "<leader>a", "<esc>ggVG<CR>") -- Select all
vim.keymap.set("n", "*", ":keepjumps normal! mi*`i<CR>") -- " Use * to add w/out jumping
vim.keymap.set("n", "&", function() -- Rename word under cursor
  vim.api.nvim_feedkeys(":keepjumps normal! mi*`i<CR>", "n", false)
  u.press_enter()
  vim.api.nvim_feedkeys(":%s//", "n", false)
end)
vim.keymap.set("v", "<leader>y", '"+y') -- Copy to clipboard
vim.keymap.set("n", "H", ":w<CR>") -- Quick save
vim.keymap.set("i", "<C-h>", "<Lseft>") -- Move left in insert
vim.keymap.set("i", "<C-l>", "<Right>") -- Move right in insert
vim.keymap.set("x", "<leader>p", '"_dP') -- Keep paste register after paste
vim.keymap.set("n", "[<space>", u.blank_line_above)
vim.keymap.set("n", "]<space>", u.blank_line_below)
vim.keymap.set("n", "[e", u.move_line_up)
vim.keymap.set("n", "]e", u.move_line_down)

-- Lua helpers
vim.keymap.set("n", "<leader>ll", ":lua ")
vim.keymap.set("n", "<leader>lp", ":lua print()<Left>")

-- Copy current path to clipboard
vim.keymap.set("n", "<leader>yd", u.copy_dir_to_clipboard)
vim.keymap.set("n", "<leader>yf", u.copy_file_to_clipboard)

-- Center the view after jumping up/down
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

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

-- Delete surrounding function call (taken from https://github.com/faceleg/delete-surrounding-function-call.vim/blob/master/plugin/delete-surrounding-function-call.vim)
vim.api.nvim_exec([[
  function! s:DeleteSurroundingFunctionCall()
    let [success, opening_bracket] = s:FindFunctionCallStart('b')
    if !success
      return
    endif
    exe 'normal! dt'.opening_bracket
    exe 'normal ds'.opening_bracket
    silent! call repeat#set('dsf')
  endfunction

function! s:FindFunctionCallStart(flags)
  if search('\k\+\zs[([]', a:flags, line('.')) <= 0
    return [0, '']
  endif
  let opener = getline('.')[col('.') - 1]
  normal! b
  let prefix = strpart(getline('.'), 0, col('.') - 1)
  while prefix =~ '\k\(\.\|::\|:\|#\)$'
    if search('\k\+', 'b', line('.')) <= 0
      break
    endif
    let prefix = strpart(getline('.'), 0, col('.') - 1)
  endwhile

  return [1, opener]
endfunction
nnoremap <silent> dsf :call <SID>DeleteSurroundingFunctionCall()<cr>
]], false)
