require('telescope').setup{ defaults = { file_ignore_patterns = {"node_modules"} } }

nnoremap('<c-f>', "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap('<c-j>', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nnoremap('<c-b>', "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap('<c-h>', "<cmd>lua require('telescope.builtin').help_tags()<cr>")

