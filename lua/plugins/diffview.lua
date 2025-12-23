local M = {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.opt.fillchars:append({ diff = "╱" })
		local actions = require("diffview.actions")
		local diffview = require("diffview")
		local git_helpers = require("git-helpers")
		local git_review_helpers = require("git-helpers.review")

		-- Diffview changes. Can be used to stage/unstage files.
		vim.keymap.set("n", "<leader>gs", function()
			local current_tab = vim.api.nvim_get_current_tabpage()
			local windows = vim.api.nvim_tabpage_list_wins(current_tab)
			local in_diffview = false
			for _, win in ipairs(windows) do
				local buf = vim.api.nvim_win_get_buf(win)
				local buf_name = vim.api.nvim_buf_get_name(buf)
				if buf_name:match("DiffviewFilePanel") then
					in_diffview = true
					break
				end
			end

			if in_diffview then
				vim.cmd("DiffviewClose")
			else
				vim.cmd(string.format("DiffviewOpen"))
			end
		end, merge(global_keymap_opts, { desc = "Toggle Diffview" }))

		-- View entire changes versus a specific branch.
		vim.keymap.set("n", "<leader>gdd", function()
			git_helpers.branch_input(function(branch)
				vim.cmd(string.format("DiffviewOpen origin/%s...HEAD -- %s", branch, git_review_helpers.ignore_paths))
			end)
		end, merge(global_keymap_opts, { desc = "Diffview all changes" }))

		-- Diffview changes of entire file history all time.
		vim.keymap.set("n", "<leader>gdf", function()
			vim.cmd("DiffviewFileHistory %")
		end, merge(global_keymap_opts, { desc = "Git view file history" }))

		diffview.setup({
			view = {
				default = {
					winbar_info = false,
				},
				file_history = {
					winbar_info = false,
				},
			},
			win_config = function()
				return {
					type = "split",
					position = "bottom",
					height = 14,
					relative = "win",
					win = vim.api.nvim_tabpage_list_wins(0)[1],
				}
			end,
			diff_binaries = false,
			use_icons = true, -- Requires nvim-web-devicons
			icons = {
				folder_closed = "",
				folder_open = "",
			},
			signs = { fold_closed = "", fold_open = "" },
			file_panel = {
				listing_style = "tree", -- One of 'list' or 'tree'
				tree_options = {
					-- Only applies when listing_style is 'tree'
					flatten_dirs = true, -- Flatten dirs that only contain one single dir
					folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
				},
			},
			enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
			default_args = {
				-- Default args prepended to the arg-list for the listed commands
				DiffviewOpen = {},
				DiffviewFileHistory = {
					-- Follow only the first parent upon seeing a merge commit.
					first_parent = true,
					-- Include all refs.
					all = true,
					-- List only merge commits.
					merges = false,
					-- List commits in reverse order.
					reverse = false,
				},
			},
			-- hooks = {
			-- 	diff_buf_win_enter = function()
			-- 		vim.opt_local.foldenable = false
			-- 	end,
			-- },
			key_bindings = {
				disable_defaults = true, -- Disable the default key bindings
				-- The `view` bindings are active in the diff buffers, only when the current
				-- tabpage is a Diffview.
				view = {
					{
						"n",
						"cc",
						function()
							vim.cmd("tabclose")
							vim.cmd("Git commit")
						end,
						{ desc = "Close diffview and commit" },
					},
					{
						"n",
						"<C-n>",
						actions.select_next_entry,
						{ desc = "Open the diff for the next file" },
					},
					{
						"n",
						"<C-p>",
						actions.select_prev_entry,
						{ desc = "Open the diff for the previous file" },
					},
					{
						"n",
						"<CR>",
						actions.goto_file_edit,
						{ desc = "Open the file in a new split in previous tabpage" },
					},
					{
						"n",
						"<C-w><C-f>",
						actions.goto_file_split,
						{ desc = "Open the file in a new split" },
					},
					{
						"n",
						"<C-w>gf",
						actions.goto_file_tab,
						{ desc = "Open the file in a new tabpage" },
					},
					{
						"n",
						"<leader>e",
						actions.focus_files,
						{ desc = "Bring focus to the files panel" },
					},
					{
						"n",
						"<leader>b",
						actions.toggle_files,
						{ desc = "Toggle the files panel" },
					},
				},
				file_panel = {
					{
						"n",
						"cc",
						function()
							vim.cmd("tabclose")
							vim.cmd("Git commit")
						end,
						{ desc = "Close diffview and commit" },
					},
					{
						"n",
						"j",
						actions.next_entry,
						{ desc = "Bring the cursor to the next file entry" },
					},
					{
						"n",
						"<down>",
						actions.next_entry,
						{ desc = "Bring the cursor to the next file entry" },
					},
					{
						"n",
						"k",
						actions.prev_entry,
						{ desc = "Bring the cursor to the previous file entry" },
					},
					{
						"n",
						"<up>",
						actions.prev_entry,
						{ desc = "Bring the cursor to the previous file entry" },
					},
					{
						"n",
						"o",
						actions.select_entry,
						{ desc = "Select entry" },
					},
					{
						"n",
						"<2-LeftMouse>",
						actions.select_entry,
						{ desc = "Select entry" },
					},
					{
						"n",
						"-",
						actions.toggle_stage_entry,
						{ desc = "Stage / unstage the selected entry" },
					},
					{
						"n",
						"S",
						actions.stage_all,
						{ desc = "Stage all entries" },
					},
					{
						"n",
						"U",
						actions.unstage_all,
						{ desc = "Unstage all entries" },
					},
					{
						"n",
						"X",
						actions.restore_entry,
						{ desc = "Restore entry to the state on the left side" },
					},
					{
						"n",
						"R",
						actions.refresh_files,
						{ desc = "Update stats and entries in the file list" },
					},
					{
						"n",
						"<S-Up>",
						actions.scroll_view(-20),
						{ desc = "Scroll view up" },
					},
					{
						"n",
						"<S-Down>",
						actions.scroll_view(20),
						{ desc = "Scroll view down" },
					},
					{
						"n",
						"<C-n>",
						actions.select_next_entry,
						{ desc = "Select next entry" },
					},
					{
						"n",
						"<C-p>",
						actions.select_prev_entry,
						{ desc = "Select previous entry" },
					},
					{
						"n",
						"gf",
						actions.goto_file,
						{ desc = "Go to file" },
					},
					{
						"n",
						"<cr>",
						actions.goto_file_tab,
						{ desc = "Go to file in new tab" },
					},
					{
						"n",
						"i",
						actions.listing_style,
						{ desc = "Toggle between 'list' and 'tree' views" },
					},
					{
						"n",
						"f",
						actions.toggle_flatten_dirs,
						{ desc = "Flatten empty subdirectories in tree listing style" },
					},
					{
						"n",
						"<leader>e",
						actions.focus_files,
						{ desc = "Focus files panel" },
					},
				},
				file_history_panel = {
					{
						"n",
						"g!",
						actions.options,
						{ desc = "Open the option panel" },
					},
					{
						"n",
						"<C-A-d>",
						actions.open_in_diffview,
						{ desc = "Open the entry under the cursor in a diffview" },
					},
					{
						"n",
						"zR",
						actions.open_all_folds,
						{ desc = "Open all folds" },
					},
					{
						"n",
						"zM",
						actions.close_all_folds,
						{ desc = "Close all folds" },
					},
					{
						"n",
						"j",
						actions.next_entry,
						{ desc = "Next entry" },
					},
					{
						"n",
						"<down>",
						actions.next_entry,
						{ desc = "Next entry" },
					},
					{
						"n",
						"k",
						actions.prev_entry,
						{ desc = "Previous entry" },
					},
					{
						"n",
						"<up>",
						actions.prev_entry,
						{ desc = "Previous entry" },
					},
					{
						"n",
						"<cr>",
						actions.select_entry,
						{ desc = "Select entry" },
					},
					{
						"n",
						"o",
						actions.select_entry,
						{ desc = "Select entry" },
					},
					{
						"n",
						"<2-LeftMouse>",
						actions.select_entry,
						{ desc = "Select entry" },
					},
					{
						"n",
						"<C-n>",
						actions.select_next_entry,
						{ desc = "Select next entry" },
					},
					{
						"n",
						"<C-p>",
						actions.select_prev_entry,
						{ desc = "Select previous entry" },
					},
					{
						"n",
						"gf",
						actions.goto_file,
						{ desc = "Go to file" },
					},
					{
						"n",
						"<C-w><C-f>",
						actions.goto_file_split,
						{ desc = "Go to file in split" },
					},
					{
						"n",
						"<C-w>gf",
						actions.goto_file_tab,
						{ desc = "Go to file in new tab" },
					},
					{
						"n",
						"<leader>e",
						actions.focus_files,
						{ desc = "Focus files panel" },
					},
					{
						"n",
						"<leader>b",
						actions.toggle_files,
						{ desc = "Toggle files panel" },
					},
					{
						"n",
						"<leader>go",
						function()
							local hash = git_helpers.get_hash()
							if hash == nil then
								return
							end
							git_helpers.github.open_pr_from_hash(hash)
						end,
						{ desc = "Open PR from hash" },
					},
				},
			},
		})
	end,
}

return M
