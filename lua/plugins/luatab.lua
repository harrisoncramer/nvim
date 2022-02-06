return {
	setup = function(remap)
		remap({ "n", "<leader>tn", ":tabnext<CR>" })
		remap({ "n", "<leader>tp", ":tabprev<CR>" })
		remap({ "n", "<leader>tc", ":tabclose<CR> | :tabprev<CR>" })
		require("luatab").setup({
			separator = function()
				return ""
			end,
		})
	end,
}
