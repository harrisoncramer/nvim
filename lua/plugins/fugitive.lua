local u = require("functions.utils")

local toggle_status = function()
	local ft = vim.bo.filetype
	if ft == "fugitive" then
		vim.api.nvim_command("bd")
	else
		vim.api.nvim_command("Git")
	end
end

local git_push = function()
	local isSubmodule = vim.fn.trim(vim.fn.system("git rev-parse --show-superproject-working-tree"))
	if isSubmodule == "" then
		if u.get_os() == "Linux" then
			vim.api.nvim_command("Git push")
		else
			vim.api.nvim_command("! git push")
		end
	else
		vim.fn.confirm("Push to origin/main branch for submodule?")
		vim.api.nvim_command("! git push origin HEAD:main")
	end
end

local git_open = function()
	vim.api.nvim_command("! git open")
end

local git_mr_open = function()
	if u.get_os() == "Linux" then
		os.execute(
			string.format(
				"firefox --new-tab 'https://gitlab.com/crossbeam/%s/-/merge_requests?scope=all&state=opened&author_username=hcramer1'",
				u.current_dir()
			)
		)
	end
end

vim.keymap.set("n", "<leader>gs", toggle_status, {})
vim.keymap.set("n", "<leader>gP", git_push, {})
vim.keymap.set("n", "<leader>goo", git_open, {})
vim.keymap.set("n", "<leader>gom", git_mr_open, {})
