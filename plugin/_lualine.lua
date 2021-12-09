require('lualine').setup({
    options = {theme = 'gruvbox-material'},
    sections = {
        lualine_x = {'filetype'},
        lualine_y = {'progress'},
        lualine_z = {}
    }
})

vim.cmd [[
  au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
]]

