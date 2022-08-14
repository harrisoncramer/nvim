local map_opts = { noremap = true, silent = true, nowait = true, buffer = true }

-- Javascript specific mappings
vim.keymap.set("n", "<localleader>(", function()
	vim.cmd("startinsert")
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("() => {}<left><CR><CR><up><tab>", false, true, true),
		"n",
		false
	)
end, map_opts)

vim.keymap.set("n", "<localleader>)", function()
	vim.cmd("startinsert")
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("() => {}<left><CR><CR><up><up><right>", false, true, true),
		"n",
		false
	)
end, map_opts)

vim.keymap.set("n", "<localleader>m", function()
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("a.map(() => {})<left><left><CR><CR><up><up><ESC>Ei", false, true, true),
		"n",
		false
	)
end, map_opts)

vim.keymap.set("n", "<localleader>f", function()
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("a.filter(() => {})<left><left><CR><CR><up><up><ESC>Ei", false, true, true),
		"n",
		false
	)
end, map_opts)

vim.keymap.set("n", "<localleader>r", function()
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("a.reduce((acc, ) => {})<left><left><CR><CR><up><up><ESC>EEi", false, true, true),
		"n",
		false
	)
end, map_opts)
