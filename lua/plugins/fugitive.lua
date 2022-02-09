local f = require("functions")

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
		if f.getOS() == "Linux" then
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
	if f.getOS() == "Linux" then
		os.execute(
			string.format(
				"firefox --new-tab 'https://gitlab.com/crossbeam/%s/-/merge_requests?scope=all&state=opened&author_username=hcramer1'",
				f.currentDir()
			)
		)
	end
end

return {
	toggle_status = toggle_status,
	git_push = git_push,
	git_open = git_open,
	git_mr_open = git_mr_open,
	setup = function()
		require("compat").remap(
			"n",
			"<leader>gs",
			toggle_status,
			{},
			":lua require('plugins/fugitive').toggle_status()<CR>"
		)
		require("compat").remap("n", "<leader>gP", git_push, {}, ":lua require('plugins/fugitive').git_push()<CR>")
		require("compat").remap("n", "<leader>go", git_open, {}, ":lua require('plugins/fugitive').git_open()<CR>")
		require("compat").remap(
			"n",
			"<leader>gm",
			git_mr_open,
			{},
			":lua require('plugins/fugitive').git_mr_open()<CR>"
		)
	end,
}
