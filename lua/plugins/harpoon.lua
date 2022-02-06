return {
	setup = function()
		require("harpoon").setup({
			mark_branch = true,
			global_settings = {
				save_on_toggle = true,
			},
			menu = {
				width = 120,
			},
		})

		require("compat").remap(
			"n",
			"<leader>hh",
			require("harpoon.ui").toggle_quick_menu,
			{},
			":lua require('harpoon.ui').toggle_quick_menu()<CR>"
		)
		require("compat").remap(
			"n",
			"<leader>ha",
			require("harpoon.mark").add_file,
			{},
			":lua require('harpoon.ui').add_file()<CR>"
		)

		vim.cmd([[
      :autocmd FileType harpoon nnoremap <buffer> <C-n> <Down>
      :autocmd FileType harpoon nnoremap <buffer> <C-p> <Up>
    ]])
	end,
}
