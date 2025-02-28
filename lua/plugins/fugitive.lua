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
		local map_opts = { noremap = true, silent = true, nowait = true, buffer = false }
		vim.keymap.set("n", "<leader>gs", toggle_status, map_opts)
	end,
}
