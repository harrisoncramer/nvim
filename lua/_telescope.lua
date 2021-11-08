local actions = require('telescope.actions')
require('telescope').setup{ 
  defaults = { 
    file_ignore_patterns = { "node_modules"},
    mappings = {
      i = {
        ['<leader><leader>q'] = actions.smart_send_to_qflist,
        ["<esc>"] = actions.close
      }
    }
  } 
}

nnoremap('<c-f>', "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap('<c-j>', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nnoremap('<c-b>', "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap('<c-h>', "<cmd>lua require('telescope.builtin').help_tags()<cr>")

