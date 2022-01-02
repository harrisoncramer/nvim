vim.cmd("set termguicolors")

local kanagawa_status_ok, kanagawa = pcall(require, "kanagawa")
if kanagawa_status_ok then
	kanagawa.setup({
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

	vim.cmd("colorscheme kanagawa")
	vim.cmd([[
  :hi NonText guifg=bg
  :set signcolumn=yes
]])
end

local nvim_web_devicons_status_ok, nvim_web_devicons = pcall(require, "null-ls")
if nvim_web_devicons_status_ok then
	nvim_web_devicons.setup({})
end
