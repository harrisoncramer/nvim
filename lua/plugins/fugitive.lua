local M = {}
M.setup = function(remap)
	remap({ "n", "<leader>gs", ':lua require("plugins.fugitive").ToggleGStatus()<CR>' })
	remap({ "n", "<leader>gl", ':lua require("plugins.fugitive").ToggleGLog()<CR>' })
	remap({ "n", "<leader>gP", ":Git push --quiet<cr>" })
	remap({ "n", "<leader>go", ":!git open<cr><cr>" })
	-- This is a remapping that I'm attempting to fix.
	vim.cmd([[ :ca x wq <CR><CR> ]])
end

M.ToggleGStatus = function()
	vim.cmd([[
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Git
    endif
  ]])
end

M.ToggleGLog = function()
	vim.cmd([[
    if buflisted(bufname('fugitive'))
      :cclose
      :execute "normal! :bdelete fugitive*\<C-a>\<CR>"
    else
      Gclog
    endif
  ]])
end

return M
