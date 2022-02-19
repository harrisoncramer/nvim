local is_diff_mode = function()
	return vim.api.nvim_win_get_option(0, "diff")
end

vim.g.mergetool_layout = "mr"
vim.g.mergetool_prefer_revision = "local"

local function mergetool_toggle()
	vim.cmd("MergetoolToggle")
	if is_diff_mode() then
		vim.cmd("LspStop")
		vim.api.nvim_feedkeys("zR", "n", false)
	else
		vim.cmd("LspStart")
	end
end

vim.keymap.set("n", "<leader>gm", mergetool_toggle, {})
