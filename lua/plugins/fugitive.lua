local f = require("functions")

return {
	setup = function(remap)
		remap({ "n", "<leader>gs", ':lua require("plugins.fugitive").toggleStatus()<CR>' })
    if f.getOS() == 'Linux' then
		  remap({ "n", "<leader>gP", ":! git push <cr>" })
		  remap({ "n", "<leader>go", ":! git open <cr>" })
    else
		  remap({ "n", "<leader>gP", ":Git push<cr>" })
		  remap({ "n", "<leader>go", ":Git open<cr>" })
    end
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
