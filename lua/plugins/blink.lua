return {
	"saghen/blink.cmp",
	dependencies = {
		"olimorris/codecompanion.nvim",
	},
	version = "*",
	opts = {
		signature = {},
		keymap = {
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "select_and_accept" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-d>"] = { "scroll_documentation_up", "fallback" },
			["<C-u>"] = { "scroll_documentation_down", "fallback" },
		},
		completion = {
			documentation = {
				auto_show = true,
			},
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			default = function()
				if vim.bo.filetype == "sql" then
					return { "dadbod" }
				end
				return { "lsp", "path", "snippets", "buffer" }
			end,
			providers = {
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				codecompanion = {
					name = "CodeCompanion",
					module = "codecompanion.providers.completion.blink",
					enabled = true,
				},
			},
		},
	},
	opts_extend = { "sources.default" },
}
