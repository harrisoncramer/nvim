local M = {}
local neogit = require("neogit")
M.setup = function(remap)
	remap({ "n", "<leader>gs", ':lua require("neogit").open({ kind = "split_above"})<CR>' })
	remap({ "n", "<leader>gP", ":lua push --quiet<cr>" })

	-- Another thing
	neogit.setup({
		disable_signs = false,
		disable_hint = false,
		disable_context_highlighting = false,
		disable_commit_confirmation = true,
		auto_refresh = true,
		disable_builtin_notifications = false,
		disable_insert_on_commit = false,
		commit_popup = {
			kind = "split_above",
		},
		signs = {
			-- { CLOSED, OPENED }
			section = { ">", "v" },
			item = { ">", "v" },
			hunk = { "", "" },
		},
		integrations = {
			-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `sindrets/diffview.nvim`.
			-- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
			--
			-- Requires you to have `sindrets/diffview.nvim` installed.
			-- use {
			--   'TimUntersberger/neogit',
			--   requires = {
			--     'nvim-lua/plenary.nvim',
			--     'sindrets/diffview.nvim'
			--   }
			-- }
			--
			diffview = true,
		},
		-- Setting any section to `false` will make the section not render at all
		sections = {
			untracked = {
				folded = false,
			},
			unstaged = {
				folded = false,
			},
			staged = {
				folded = false,
			},
			stashes = {
				folded = true,
			},
			unpulled = {
				folded = true,
			},
			unmerged = {
				folded = false,
			},
			recent = {
				folded = true,
			},
		},
		-- override/add mappings
		mappings = {
			-- modify status buffer mappings
			status = {
				["B"] = "BranchPopup",
				-- Removes the default mapping of "s"
				-- ["s"] = "",
			},
		},
	})
end
return M
