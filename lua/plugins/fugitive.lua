return {
	setup = function(remap)
		remap({ "n", "<leader>gs", ':lua require("plugins.fugitive").toggleStatus()<CR>' })
    if vim.fn.has("macunix") then
		  remap({ "n", "<leader>gP", ":Git push --quiet<cr>" })
    else
		  remap({ "n", "<leader>gP", ":! git push --quiet<cr>" })
    end
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
