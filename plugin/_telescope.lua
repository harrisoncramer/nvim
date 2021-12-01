local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    hidden = true,
    file_ignore_patterns = { "node_modules", "package%-lock.json" },
    mappings = {
      i = {
        ["<esc>"] = actions.close
      }
    }
  }
}

nnoremap('<c-j>', "<cmd>lua require('telescope.builtin').find_files{ layout_strategy = 'vertical', find_command = {'rg', '--files', '--hidden', '-g', '!node_modules/**'}}<cr>")
nnoremap('<c-f>', "<cmd>lua require('telescope.builtin').live_grep({ layout_strategy = 'vertical', hidden = true })<cr>")
nnoremap('<c-g>', "<cmd>lua require('telescope.builtin').file_browser({ hidden = true })<cr>")
nnoremap('<c-b>', "<cmd>lua require('telescope.builtin').buffers({ hidden = true })<cr>")

-- Telescope mappings start with s

-- Find current word under cursor in project
vim.cmd[[
  nnoremap <expr> <leader>sf ':Telescope live_grep<cr>' . expand('<cword>')
]]
