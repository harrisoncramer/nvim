local function toggleQf()
	local ft = vim.bo.filetype
	if ft == "qf" then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end

vim.keymap.set("n", "<leader>q", toggleQf, {})
require("bqf").setup({
	func_map = {
		cool = function()
			print("wow")
		end,
	},
	preview = {
		border_chars = { "│", "│", "─", "─", "╭", "╮", "╰", "╯", "│" },
	},
	filter = {
		fzf = {
			action_for = {
				["enter"] = "signtoggle",
			},
		},
	},
})
