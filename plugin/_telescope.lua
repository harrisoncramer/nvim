local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    hidden = true,
    layout_strategy = 'vertical',
    file_ignore_patterns = { "node_modules", "package%-lock.json" },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = require('telescope.actions').cycle_history_next,
        ["<C-k>"] = require('telescope.actions').cycle_history_prev,
      }
    }
  }
}

nnoremap('<c-j>', "<cmd>lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '-g', '!node_modules/**'}}<cr>")
nnoremap('<c-f>', "<cmd>lua require('telescope.builtin').live_grep({ hidden = true })<cr>")
nnoremap('<c-g>', "<cmd>lua require('telescope.builtin').file_browser({ hidden = true })<cr>")
nnoremap('<c-b>', "<cmd>lua require('telescope.builtin').buffers({ hidden = true })<cr>")

-- Telescope mappings start with s
-- Find current word under cursor in project
vim.cmd[[
  nnoremap <expr> <leader>sf ':Telescope live_grep<cr>' . expand('<cword>')
]]
