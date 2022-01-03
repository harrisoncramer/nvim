return {
	setup = function(remap)
		require("kanagawa").setup({
			undercurl = true, -- enable undercurls
			commentStyle = "italic",
			functionStyle = "NONE",
			keywordStyle = "italic",
			statementStyle = "NONE",
			typeStyle = "NONE",
			variablebuiltinStyle = "italic",
			specialReturn = true, -- special highlight for the return keyword
			specialException = true, -- special highlight for exception handling keywords
			transparent = false, -- do not set background color
			colors = {},
			overrides = {},
		})
	end,
}
