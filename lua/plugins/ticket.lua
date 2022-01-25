return {
	setup = function(remap)
		remap({ "n", "<leader>sr", ":lua require('functions').refreshSession()<CR>" })

		-- Automatically saves a session on quit, and you can manually reopen
		-- the session for your current branch with <leader>so
		vim.cmd([[
      augroup autosession
        autocmd!
        :autocmd VimLeavePre * :lua require("functions").closeVim()
      augroup END
    ]])
	end,
}
