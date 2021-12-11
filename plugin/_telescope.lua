local remap = _G.remap
local actions = require('telescope.actions')
local state = require('telescope.actions.state')

require('telescope').setup {
    defaults = {
        hidden = true,
        layout_strategy = 'vertical',
        file_ignore_patterns = {"node_modules", "package%-lock.json"},
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-j>"] = actions.cycle_history_next,
                ["<C-k>"] = actions.cycle_history_prev
            }
        }
    },
    pickers = {
      git_commits = {
        mappings = {
          i = {
            ["<C-o>"] = function(prompt_bufnr)
              actions.close(prompt_bufnr)
              local value = state.get_selected_entry(prompt_bufnr).value
              vim.cmd('DiffviewOpen ' .. value .. '~1..' .. value)
            end,
          }
        }
      }
    }
}

remap { 'n', '<C-f>', ":lua require('telescope.builtin').live_grep({ hidden = true })<cr>" }
remap { 'n', '<C-j>', ":lua require('telescope.builtin').git_files{ find_command = {'rg', '--files', '--hidden', '-g', '!node_modules/**'}}<cr>" }
remap { 'n', '<C-b>', ":lua require('telescope.builtin').buffers({ hidden = true })<cr>" }
remap { 'n', '<leader>tr', ':Telescope oldfiles<cr>' } -- "recent files"
remap { 'n', '<leader>td', ':Telescope lsp_document_diagnostics<cr>' }
remap { 'n', '<leader>tg', ':Telescope git_commits<cr>' }
