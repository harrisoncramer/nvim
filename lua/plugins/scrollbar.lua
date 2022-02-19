local colors = require("kanagawa.colors").setup()
require("scrollbar").setup({
	show = true,
	handle = {
		text = " ",
		color = colors.waveBlue1,
		hide_if_all_visible = true, -- Hides handle if all lines are visible
	},
	marks = {
		Search = { text = { "-", "=" }, priority = 0, color = "orange" },
		Error = { text = { "-", "=" }, priority = 1, color = "red" },
		Warn = { text = { "-", "=" }, priority = 2, color = "yellow" },
		Info = { text = { "-", "=" }, priority = 3, color = "blue" },
		Hint = { text = { "-", "=" }, priority = 4, color = "green" },
		Misc = { text = { "-", "=" }, priority = 5, color = "purple" },
	},
	excluded_filetypes = {
		"",
		"prompt",
		"TelescopePrompt",
	},
	autocmd = {
		render = {
			"BufWinEnter",
			"TabEnter",
			"TermEnter",
			"WinEnter",
			"CmdwinLeave",
			"TextChanged",
			"VimResized",
			"WinScrolled",
		},
	},
	handlers = {
		diagnostic = true,
		search = true,
	},
})
