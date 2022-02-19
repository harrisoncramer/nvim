local fTerm = require("FTerm")
return {

	setup = function(remap)
		vim.keymap.set("n", "<C-z>", fTerm.toggle, {})
		remap({ "t", "<C-z>", '<C-\\><C-n>:lua require("FTerm").toggle()<CR>' })
	end,
}
