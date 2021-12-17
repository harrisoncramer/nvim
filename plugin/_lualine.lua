require('lualine').setup({
    options = {theme = 'gruvbox-material'},
    sections = {
        lualine_a = {'branch'},
        lualine_b = {'diagnostics', 'diff'},
        lualine_c = {"vim.fn.expand('%')"},
        lualine_x = {'filetype'},
        lualine_y = {'os.date("%I:%M:%S", os.time())'},
        lualine_z = {}
    }
})

vim.cmd [[
  au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
]]

if _G.Statusline_timer == nil then
    _G.Statusline_timer = vim.loop.new_timer()
else
    _G.Statusline_timer:stop()
end
_G.Statusline_timer:start(0, 1000, vim.schedule_wrap(
                              function() vim.api.nvim_command('redrawstatus') end))
