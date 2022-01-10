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
	local isSubmodule = vim.api.nvim_command("!git rev-parse --show-superproject-working-tree")
	if not isSubmodule == nil then
		vim.fn.confirm("Push to upstream branch for submodule?")
		vim.api.nvim_command("! git push origin HEAD:main")
	else
		if f.getOS() == "Linux" then
			vim.api.nvim_command("Git push")
		else
			vim.api.nvim_command("! git push")
		end
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
