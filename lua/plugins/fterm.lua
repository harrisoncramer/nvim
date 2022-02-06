return {
	setup = function(remap)
		local fTerm = require("FTerm")
		require("compat").remap("n", "<C-z>", fTerm.toggle, {}, ":lua require('FTerm').toggle()<CR>")
		remap({ "t", "<C-z>", '<C-\\><C-n>:lua require("FTerm").toggle()<CR>' })
	end,
}
