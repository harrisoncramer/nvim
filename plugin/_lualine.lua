local function get_git_head()
    local head = vim.call('FugitiveHead')
    if (string.len(head) > 20) then head = ".." .. head:sub(15) end
    return " " .. head
end

require('lualine').setup({
    options = {
        component_separators = {right = ''},
        section_separators = {left = '', right = ''},
        theme = 'gruvbox-material'
    },
    sections = {
        lualine_a = {get_git_head},
        lualine_b = {'diff', 'diagnostics'},
        lualine_c = {"vim.fn.expand('%')"},
        lualine_d = {},
        lualine_x = {'filetype'},
        lualine_y = {
            {
                'tabs',
                mode = 0,
                tabs_color = {
                    inactive = {bg = '504c4c'}, -- color for active tab
                    active = {fg = 'black', bg = 'ffac04'}
                }
            }
        },
        lualine_z = {'os.date("%I:%M:%S", os.time())'}
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
