vim.cmd([[
  let test#strategy = "neovim"
  let g:test#echo_command = 0
  " let test#neovim#term_position = "vert"
]])

local map_opts = { noremap = true, silent = true, nowait = true }

vim.keymap.set("n", "<localleader>tr", function()
	vim.cmd("let g:test#neovim#start_normal = 0")
	vim.cmd(":TestNearest")
end, map_opts)

vim.keymap.set("n", "<localleader>tw", function()
	vim.cmd("let g:test#neovim#start_normal = 1")
	vim.cmd(":TestNearest --watch")
end, map_opts)

vim.keymap.set("n", "<localleader>tfr", function()
	vim.cmd(":TestFile")
end, map_opts)

vim.keymap.set("n", "<localleader>tfw", function()
	vim.cmd(":TestFile --watch")
end, map_opts)
