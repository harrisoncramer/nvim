local toggle_status = function()
	local ft = vim.bo.filetype
	if ft == "fugitive" then
		vim.cmd("bd")
	else
		vim.cmd("silent! Git")
	end
end

return {
	"tpope/vim-fugitive",
	init = function()
		vim.keymap.set("n", "<leader>gs", toggle_status, merge(global_keymap_opts, { desc = "Toggle git status" }))
	end,
}
