vim.api.nvim_create_autocmd("FileType", {
	pattern = "codecompanion",
	command = "Markview attach",
})

vim.keymap.set("n", "<localleader>r", "<cmd>Markview toggle<cr>", { desc = "Toggle markview" })

local function make_headings_bold()
	local groups = {
		"MarkviewPalette1Fg",
		"MarkviewPalette2Fg",
		"MarkviewPalette3Fg",
		"MarkviewPalette4Fg",
		"MarkviewPalette5Fg",
		"MarkviewPalette6Fg",
	}
	for _, group in ipairs(groups) do
		local existing = vim.api.nvim_get_hl(0, { name = group })
		if existing and next(existing) then
			existing.bold = true
			vim.api.nvim_set_hl(0, group, existing)
		end
	end
end

return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	config = function(_, opts)
		require("markview").setup(opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "MarkviewAttach",
			callback = function(args)
				make_headings_bold()
				vim.wo[vim.fn.bufwinid(args.buf)].wrap = true
			end,
		})
	end,
	opts = {
		preview = {
			icon_provider = "devicons",
			filetypes = {
				"markdown",
			},
		},
		markdown = {
			list_items = {
				shift_width = 0,
			},
			headings = {
				shift_width = 2,
				org_indent = true,
				org_shift_width = 2,
				heading_1 = {
					style = "icon",
					hl = "MarkviewPalette1Fg",
					icon = "",
					icon_hl = "MarkviewPalette1Fg",
					sign = false,
				},
				heading_2 = {
					style = "icon",
					hl = "MarkviewPalette2Fg",
					icon = "",
					icon_hl = "MarkviewPalette2Fg",
					sign = false,
				},
				heading_3 = {
					style = "icon",
					hl = "MarkviewPalette3Fg",
					icon_hl = "MarkviewPalette3Fg",
					icon = "",
					sign = false,
				},
				heading_4 = {
					style = "icon",
					hl = "MarkviewPalette4Fg",
					icon = "",
					icon_hl = "MarkviewPalette4Fg",
					sign = false,
				},
				heading_5 = {
					style = "icon",
					hl = "MarkviewPalette5Fg",
					icon = "",
					icon_hl = "MarkviewPalette5Fg",
					sign = false,
				},
				heading_6 = {
					style = "icon",
					hl = "MarkviewPalette6Fg",
					icon = "",
					icon_hl = "MarkviewPalette6Fg",
					sign = false,
				},
			},
		},
	},
}
