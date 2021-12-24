local M = {}
M.setup = function()
    require('nvim-autopairs').setup({
        disable_filetype = {"TelescopePrompt"},
        enable_check_bracket_line = false
    })
end

return M
