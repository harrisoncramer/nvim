return {
	setup = function(remap)
		remap({ "n", "<leader>gs", ':lua require("plugins.fugitive").toggleStatus()<CR>' })
		remap({ "n", "<leader>gP", ":Git push --quiet<cr>" })
		remap({ "n", "<leader>go", ":Git open<cr>" })
	end,
	toggleStatus = function()
		vim.cmd([[
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Git
    endif
  ]])
	end,
}
