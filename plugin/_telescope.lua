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

-- Core mappings use CTRL
nnoremap('<c-j>', "<cmd>lua require('telescope.builtin').find_files{ find_command = {'rg', '--files', '--hidden', '-g', '!node_modules/**'}}<cr>")
nnoremap('<c-f>', "<cmd>lua require('telescope.builtin').live_grep({ hidden = true })<cr>")
nnoremap('<c-g>', "<cmd>lua require('telescope.builtin').file_browser({ hidden = true })<cr>")
nnoremap('<c-b>', "<cmd>lua require('telescope.builtin').buffers({ hidden = true })<cr>")

-- Other telescope mappings start with T
nnoremap('<leader>th', "<cmd>lua require('telescope.builtin').oldfiles({ hidden = true })<cr>")

vim.cmd[[
  nnoremap <expr> <leader>tf ':Telescope live_grep<cr>' . expand('<cword>')
]]
