local M = {}
M.setup = function()
	-- For rainbow brackets
	local enabled_list = { "clojure" }
	local parsers = require("nvim-treesitter.parsers")

	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		sync_install = false,
		ignore_install = { "haskell" },
		highlight = {
			enable = true, -- false will disable the whole extension
			disable = { "c", "rust" }, -- list of language that will be disabled
			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
		-- Rainbow parens plugin
		rainbow = {
			enable = true,
			-- Enable only for lisp like languages
			disable = vim.tbl_filter(function(p)
				local disable = true
				for _, lang in pairs(enabled_list) do
					if p == lang then
						disable = false
					end
				end
				return disable
			end, parsers.available_parsers()),
		},
		matchup = { enable = true },
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
	})

	-- vim.cmd [[
	--   set foldmethod=expr
	--   set foldexpr=nvim_treesitter#foldexpr()
	--   au BufWinEnter * normal zR
	-- ]]
end
return M
