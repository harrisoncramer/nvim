return {
	stash = function(name)
		vim.fn.system("git stash -u -m " .. name)
	end,
}
