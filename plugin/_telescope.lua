local remap = _G.remap
local M = {}
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        hidden = true,
        layout_strategy = 'vertical',
        file_ignore_patterns = {"node_modules", "package%-lock.json"},
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-j>"] = require('telescope.actions').cycle_history_next,
                ["<C-k>"] = require('telescope.actions').cycle_history_prev
            }
        }
    }
}

local action_state = require('telescope.actions.state')

local open_dif = function()
    local selected_entry = action_state.get_selected_entry()
    local value = selected_entry['value']
    vim.api.nvim_win_close(0, true)
    local cmd = 'DiffviewOpen ' .. value
    vim.cmd(cmd)
end

M.git_commit = function()
    require('telescope.builtin').git_commits({
        attach_mappings = function(_, map)
            map('n', '<c-o>', open_dif)
            return true
        end
    })
end

remap { 'n', '<C-f>', "<cmd>lua require('telescope.builtin').live_grep({ hidden = true })<cr>" }
remap { 'n', '<C-j>', ":lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '-g', '!node_modules/**'}}<cr>" }
remap { 'n', '<C-g>', ":lua require('telescope.builtin').live_grep({ hidden = true })<cr>" }
remap { 'n', '<C-b>', ":lua require('telescope.builtin').buffers({ hidden = true })<cr>" }
remap { 'n', '<leader>th', ':Telescope oldfiles<cr>' }
remap { 'n', '<leader>td', ':Telescope lsp_document_diagnostics<cr>' }
remap { 'n', '<leader>tg', ':Telescope git_commits<cr>' }

-- vim.cmd [[
--   nnoremap <expr> <leader>tF ':Telescope live_grep<cr>' . expand('<cword>')
--   nnoremap <expr> <leader>tf ':Telescope find_files<cr>' . expand('<cword>')
-- ]]

return M
