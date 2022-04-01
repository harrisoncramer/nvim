-- For rainbow brackets
local enabled_list = { "clojure" }
local parsers = require("nvim-treesitter.parsers")

local disable_function = function(lang, bufnr)
	if not bufnr then
		bufnr = 0
	end
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	if line_count > 20000 or (line_count == 1 and lang == "json") then
		vim.g.matchup_matchparen_enabled = 0
		return true
	else
		return false
	end
end

require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	sync_install = false,
	ignore_install = { "haskell", "phpdoc" },
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = disable_function,
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
	matchup = {
		enable = true,
		disable = { "json", "csv" },
	},
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
