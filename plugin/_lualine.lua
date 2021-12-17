require('lualine').setup({
    options = {theme = 'gruvbox-material'},
    sections = {
        lualine_a = {'branch'},
        lualine_b = {'diagnostics', 'diff'},
        lualine_c = {"vim.fn.expand('%')"},
        lualine_x = {'filetype'},
        lualine_y = {'progress'}
    }
})

vim.cmd [[
  au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
]]
