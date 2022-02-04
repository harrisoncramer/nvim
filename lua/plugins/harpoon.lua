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

		vim.keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu)
		vim.keymap.set("n", "<leader>ha", require("harpoon.mark").add_file)

		vim.cmd([[
      :autocmd FileType harpoon nnoremap <buffer> <C-n> <Down>
      :autocmd FileType harpoon nnoremap <buffer> <C-p> <Up>
    ]])
	end,
}
