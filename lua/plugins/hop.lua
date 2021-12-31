local M = {}
M.setup = function(remap)
	require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })

	-- The vaunted leader-f hop to character navigation!
	remap({ "n", "<leader>f", ":HopChar2<CR>" })
end
return M
