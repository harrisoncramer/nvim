local qf = require("plugins.bqf.quickfix")
local group = vim.api.nvim_create_augroup("QuickfixKeymaps", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "dd", qf.remove_current_qf_item, {
			buffer = true,
			desc = "Remove quickfix item and update file",
		})
	end,
})

vim.keymap.set("n", "<leader>qq", qf.toggle_qf, merge(global_keymap_opts, { desc = "Toggle quickfix" }))

vim.keymap.set(
	"n",
	"<leader>qm",
	qf.manage_quickfix_list,
	merge(global_keymap_opts, { desc = "Manage quickfix lists" })
)
vim.keymap.set(
	"n",
	"<leader>qs",
	qf.save_quickfix_to_file,
	merge(global_keymap_opts, { desc = "Save quickfix manually" })
)
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
			open = "<CR>",
			tab = "t",
			openc = "e",
			ovsplit = "<C-v>",
			prevfile = "<C-p>",
			nextfile = "<C-n>",
			nexthist = ">",
			prevhist = "<",
			stoggleup = "<S-Tab>",
			stoggledown = "<Tab>",
			stogglevm = "<Tab>",
			stogglebuf = "<Tab>",
			fzffilter = "/",
			ptoggleauto = "P",
			filter = "zn",
			filterr = "zN",
			sclear = "z<Tab>",
		},
	},
}
