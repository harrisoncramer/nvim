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
	local isSubmodule = vim.fn.trim(vim.fn.system("git rev-parse --show-superproject-working-tree"))
	if isSubmodule == "" then
		if f.getOS() == "Linux" then
			vim.api.nvim_command("Git push")
		else
			vim.api.nvim_command("! git push")
		end
	else
		vim.fn.confirm("Push to upstream branch for submodule?")
		vim.api.nvim_command("! git push origin HEAD:main")
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
