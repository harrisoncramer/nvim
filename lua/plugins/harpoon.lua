return {
  setup = function(remap)
    require('harpoon').setup({
      global_settings = {
        save_on_toggle = true,
      },
      menu = {
        width = 120,
      }
    })

    remap({ "n", "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<CR>"})
    remap({ "n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>"})

    vim.cmd[[
      :autocmd FileType harpoon nnoremap <buffer> <C-n> <Down>
      :autocmd FileType harpoon nnoremap <buffer> <C-p> <Up>
    ]]
  end
}
