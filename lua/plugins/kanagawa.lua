local strongHighlight = "#fa7af6"
return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		-- Make background transparent. I like semi-transparent background in the terminal.
		vim.cmd([[
    augroup user_colors
      autocmd!
      autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
    augroup END
  ]])

		-- Don't highlight lines from the quickfix view
		vim.cmd([[
    highlight! link QuickFixLine Normal
      ]])

		require("kanagawa").setup({
			undercurl = true, -- enable undercurls
			commentStyle = {
				italic = true,
			},
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
			functionStyle = {},
			keywordStyle = {
				italic = true,
			},
			statementStyle = {},
			typeStyle = {},
			variablebuiltinStyle = {
				italic = true,
			},
			overrides = function(colors)
				local theme = colors.theme
				return {
					IncSearch = { fg = "black", bg = strongHighlight, underline = true, bold = true },
					Search = { fg = "black", bg = colors.palette.oniViolet },
					Substitute = { fg = "black", bg = colors.palette.strongHighlight },
					Pmenu = { fg = theme.ui.shade0, bg = colors.palette.sumiInk3 },
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p4 },
					PmenuSbar = { bg = theme.ui.bg_p2 },
					PmenuThumb = { bg = theme.ui.bg_p2 },
				}
			end,
			specialReturn = true, -- special highlight for the return keyword
			specialException = true, -- special highlight for exception handling keywords
			transparent = false, -- do not set background color
		})

		vim.cmd.hi("NonText guifg=bg")
		vim.cmd("colorscheme kanagawa")

		-- Highlight active line
		vim.opt.cursorline = true
		vim.opt.cursorlineopt = "number"
		vim.cmd.highlight("CursorLineNr guibg=#1a1a22")
		vim.cmd.highlight("SignColumnNr guibg=#1a1a22")
	end,
}
