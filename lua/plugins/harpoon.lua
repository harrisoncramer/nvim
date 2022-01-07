return {
  setup = function(remap)
    remap({ "n", "<leader>hh", ":lua require(\"harpoon.ui\").toggle_quick_menu()<CR>"})
    remap({ "n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>"})
  end
}
