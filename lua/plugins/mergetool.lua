local is_diff_mode = require("functions").is_diff_mode

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

require("compat").remap(
	"n",
	"<leader>gm",
	mergetool_toggle,
	{},
	":lua require('plugins.mergetool').mergetool_toggle()<CR>"
)

return {
	mergetool_toggle = mergetool_toggle,
}
