return {
	setup = function(remap)
		remap({ "n", "<leader>ss", ":SaveSession<CR>" })
		remap({ "n", "<leader>so", ":OpenSession<CR>" })

		vim.cmd([[
      augroup autosession
        autocmd!
        au VimLeavePre * NvimTreeClose
        au VimLeavePre * SaveSession
      augroup END
    ]])
	end,
}
