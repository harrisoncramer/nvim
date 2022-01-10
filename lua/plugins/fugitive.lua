local f = require("functions")

local toggleStatus = function()
	local ft = vim.bo.filetype
	if ft == "fugitive" then
		vim.api.nvim_command("bd")
	else
		vim.api.nvim_command("Git")
	end
end

local gitPush = function()
	if f.getOS() == "Linux" then
		vim.api.nvim_command("Git push")
	else
		vim.api.nvim_command("! git push")
	end
end

local gitOpen = function()
	if f.getOS() == "Linux" then
		vim.api.nvim_command("Git open")
	else
		vim.api.nvim_command("! git open")
	end
end

return {
	setup = function()
		vim.keymap.set("n", "<leader>gs", toggleStatus)
		vim.keymap.set("n", "<leader>gP", gitPush)
		vim.keymap.set("n", "<leader>go", gitOpen)
	end,
}
