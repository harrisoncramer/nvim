return {
	setup = function(remap)
		local fTerm = require("FTerm")
		vim.keymap.set("n", "<C-z>", fTerm.toggle)
		remap({ "t", "<C-z>", '<C-\\><C-n>:lua require("FTerm").toggle()<CR>' })
	end,
}
