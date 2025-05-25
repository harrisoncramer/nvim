local qf = require("plugins.bqf.quickfix")

local function toggleQf()
	local ft = vim.bo.filetype
	if ft == "qf" then
		vim.cmd.cclose()
	else
		vim.cmd.copen()
	end
end

vim.keymap.set("n", "<leader>qq", toggleQf, merge(global_keymap_opts, { desc = "Toggle quickfix" }))
vim.keymap.set("n", "<leader>qm", qf.manage_quickfix_list, merge(global_keymap_opts, { desc = "Toggle quickfix" }))
vim.keymap.set("n", "<leader>qs", qf.save_quickfix_to_file, merge(global_keymap_opts, { desc = "Toggle quickfix" }))
vim.keymap.set("n", "]q", ":cnext<CR>", merge(global_keymap_opts, { desc = "Next quickfix" }))
vim.keymap.set("n", "[q", ":cprev<CR>", merge(global_keymap_opts, { desc = "Previous quickfix" }))

return {
	"kevinhwang91/nvim-bqf",
	dependencies = {
		{
			"junegunn/fzf",
			run = function()
				vim.fn["fzf#install"]()
			end,
		},
	},
	config = {
		border = "rounded",
		preview = { winblend = 0 },
		func_map = {
			open = "<CR>", -- Open in same buffer, stay in quickfix window (default behavior)
			tab = "t", -- Open the item in a new tab
			openc = "e", -- Open the item and close the quickfix window
			ovsplit = "<C-v>", -- Open the item in a vertical split
			prevfile = "<C-p>", -- Next or previous entry
			nextfile = "<C-n>",
			nexthist = ">", -- Move to next quickfix list
			prevhist = "<",
			stoggleup = "<S-Tab>", -- Select item (do not change)
			stoggledown = "<Tab>",
			stogglevm = "<Tab>",
			stogglebuf = "<Tab>",
			-- pscrollup = '<C-u>',
			-- pscrolldown = '<C-d>',
			fzffilter = "/", -- Open FZF filter
			ptoggleauto = "P", -- Enable/disable preview
			filter = "zn", -- Create new quickfix with results of selection
			filterr = "zN", -- Create new quickfix with inverse of selection
			sclear = "z<Tab>", -- Clear selections
		},
	},
}
