local colors = require("colorscheme")
return {
	"alvarosevilla95/luatab.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	config = function()
		vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", merge(global_keymap_opts, { desc = "Next tab" }))
		vim.keymap.set("n", "<leader>tp", ":tabprev<CR>", merge(global_keymap_opts, { desc = "Previous tab" }))
		vim.keymap.set("n", "<leader>tc", ":bd<CR>", merge(global_keymap_opts, { desc = "Close tab" }))
		require("luatab").setup({
			devicon = function()
				return ""
			end,
			separator = function(v)
				return ""
			end,
		})
		vim.api.nvim_set_hl(0, "TabLineSel", { bg = colors.crystalBlue, fg = "black" })
		vim.api.nvim_set_hl(0, "TabLine", { bg = colors.backgroundDark })
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = colors.backgroundDark })
	end,
}
